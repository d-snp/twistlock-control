module TwistlockControl
	# ProvisioningConfiguration holds service instance configuration that
	# pertains to the provisioning of containers.
	class ProvisioningConfiguration < Entity
		attribute :service_id

		def self.new(attrs)
			if attrs['configurations'] || attrs[:configurations]
				obj = CompositeConfiguration.allocate
			else
				obj = ContainerConfiguration.allocate
			end
			obj.send :initialize, attrs
		end
	end

	# Maybe we want ContainerConfiguration to be an entity with its
	# own repository, so we can simply refer to it by id.
	# That will make getting events from the provisioner easier
	class ContainerConfiguration < ProvisioningConfiguration
		attribute :provisioner_id
		attribute :container_instance_id

		attribute :mount_points
		attribute :environment_variables

		def provision
			@container_instance_id = provisioner.provision(self).id
		end

		def provisioner
			@provisioner ||= Provisioner.find_by_id(provisioner_id)
		end

		def provisioner=(provisioner)
			@provisioner = provisioner
			@provisioner_id = provisioner.id
		end

		def container
			@container ||= Container.find_by_id(service_id)
		end

		def container_instance
			@container_instance ||= ContainerInstance.find_by_id(container_instance_id)
		end

		def container_configurations
			[self]
		end
	end

	# Configuration for a composite service
	class CompositeConfiguration < ProvisioningConfiguration
		attribute :configurations, [ProvisioningConfiguration]

		def serialize
			serialized = super
			serialized[:configurations] = configurations.map(&:serialize)
			serialized
		end

		def container_configurations
			configurations.flat_map(&:container_configurations)
		end
	end
end
