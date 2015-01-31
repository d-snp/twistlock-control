module TwistlockControl
	# A service instance is an entity that represents an instance of a service
	# that can be started and stopped. For example, an operator might define a Forum
	# service and then spawn a Forum service instance for each of his customers.
	# Each of the Forum services can be referenced by name and stopped and started
	# independantly, and consist of separate container instances.
	#
	# A service instance has all runtime configuration such as mount points and
	# environment variables.
	#
	# An operator should be able to assign containers to provisioners, and configure
	# their runtime configuration.
	#
	# The configuration has a tree structure. For each composite service there will
	# be a branch element, for every container a leaf.
	class ServiceInstance < PersistedEntity
		repository ServiceInstanceRepository

		attribute :id, String, default: :generate_id
		attribute :name, String
		attribute :service_id, String
		attribute :configuration, ProvisioningConfiguration

		# We want to tell all containers how they are linked to eachother.
		# Composite services have the information about which links exist.
		# How many instances there are of a container should be configured
		# at runtime. Can we just do it by adding ContainerConfigurations
		# to a CompositeConfiguration? That would mean the build_configuration
		# method would have to only build composite configurations, leaving
		# the filling in of container configurations to the interactive
		# resource allocation process. I.E. the user would create a composite
		# configuration, then for each container needed of each composite
		# service they would select on which machine(s) any containers will
		# be ran. When a container configuration is created it can be
		# determined to which other container configuration it is linked.
		#
		# So the next step is to change build_configuration to reflect that,
		# then we add methods to CompositeConfiguration that allow to convenient
		# addition of ContainerConfigurations. Including a way to enumerate
		# which containers are needed.
		#
		# We also need to think about the linking, at the moment the provisioner
		# can link a container to any ip address. When the containers are
		# on separate machines, we can not usually link the containers directly
		# on ip, a link would first have to be established. I envisioned this
		# would ideally be through a simple TLS tunnel established by an ambassador
		# container.
		#
		# If we would go for the ambassador approach the Twistlock system would
		# have to be aware of this as it would have to provision ambassador nodes
		# and use the ip addresses of the ambassador nodes to connect across machines.
		#
		# Alternatively, we could assume all machines in the cluster are in the
		# same IP space and simply link them together. This would move the encryption
		# and network management to a separate level and would ideally be a superior
		# architecture, but in practice there is no simple way of achieving this
		# in a way that is compatible with all container providers and all hosts.
		# Since we want Twistlock to be an easy to deploy integrated solution,
		# Twistlock would have to supply an automatic way of configuring such a
		# datacenter without messing with existing architecture too much. A complex
		# task that's not guaranteed to have a perfect solution.
		#
		# We could also for now simply assume a flat ip space, and work on the
		# ambassador system later. A downside of that is that we might miss some
		# architectural decision would enable the ambassador system to be more neatly
		# integrated. So let's thing about the ambassador approach first.
		#
		# During the provisioning assignment step, it would become clear on which
		# machine a process is going to be provisioned. If a linked container is
		# on a different machine, the system detects it and links the container
		# into an ambassador.
		#
		# Easiest will be to have a single ambassador per host. We could inform the
		# ambassador of a cross-machine link via a HTTP POST, to which it would respond
		# with the port numbers it will use for the link.
		# Nice thing about this approach is that we can simply assume the ambassador
		# is always there, so no complex logic for spawning it. Also it would be really
		# easy to disable it and work with a flat ip space.
		#
		# So now the provisioning assignment step will be like this, for each container:
		#    - pick a machine it will run on
		#    - select any mounts
		#    - configure any environment variables
		#
		# Then the provisioning preparation process will be:
		#    - make sure all hosts have container descriptions/images
		#    - determine all cross-machine links
		#    - inform ambassadors of links
		#
		# Then the provisioning process itself:
		#    - start each container on its host
		#    - fill in ip-addresses of container instances
		#    - whenever a container is live, determine if any of its links can be
		#      established, and if so establish them
		#
		# Basically the only thing we need to make sure in the architecture is that it can
		# be deduced from the link information whether the link is remote or local, so
		# the system can decide if it has to go through an ambassador.

		def generate_id
			name
		end

		def self.create(name, service)
			configuration = build_configuration(service)
			instance = new(service_id: service.id, name: name, configuration: configuration)
			instance.save
			instance
		end

		def self.build_configuration(service)
			case service.service_type
			when :container then ContainerConfiguration.new(service_id: service.id)
			when :composite
				CompositeConfiguration.new(
					service_id: service.id,
					configurations: service.services.map { |s| build_configuration(s) }
				)
			else
				fail "Unknown service type: #{service.service_type}"
			end
		end

		def provision
			container_configurations.map(&:provision)
		end

		def container_configurations
			configuration.container_configurations
		end

		def service
			Service.find_by_id(service_id)
		end

		def serialize
			serialized = attributes.dup
			serialized[:configuration] = configuration.serialize
			serialized
		end
	end
end
