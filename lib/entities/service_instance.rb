module TwistlockControl
	class Configuration < Entity
		attribute :service_id
	end

	class ContainerConfiguration < Configuration
		attribute :provisioner_id

		# Runtime configurable settings
		attribute :mount_points
		attribute :environment_variables

		# Attributes as dictated by provisioner
		attribute :container_id
		attribute :ip_address
	end

	class CompositeConfiguration < Configuration
		attribute :configurations, [Configuration]
	end

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
	class ServiceInstance < Entity
		attribute :id, String
		attribute :name, String
		attribute :service_id, String
		attribute :configuration, Configuration

		def self.create(service, name)
			configuration = build_configuration(service)
			instance = new(service_id: service.id, name: name, configuration: configuration)
		end

		def self.build_configuration(service)
			case service.service_type
			when :container
				c = ContainerConfiguration.new(service_id: service.id)
			when :composite
				c = CompositeConfiguration.new(service_id: service.id, configurations: service.services.map{|s| build_configuration(s)})
			else
				raise "Unknown service type: #{service.service_type}"
			end
			c
		end

		# TODO test if building configurations like this works, whether it's sane, whether
		# we can use this to configure for provisioning, and find out and implement how to
		# provision containers from these configuration settings.

		def service
			Service.find(service_id)
		end
	end
end
