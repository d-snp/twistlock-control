module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Provisioning service instances on provisioners
		module ContainerInstance
			# Provision takes a ContainerConfiguration and when
			# it is done provisioning it will notify the ContainerConfiguration
			# of the ip address and container id of the provisioned container.
			def self.add(container_configuration)
				# TODO: figure out how to have internal actions like provisioning
				# without polluting the entities with logic
				provisioner = container_configuration.provisioner.api
				properties = provisioner.provision_container(container_configuration)
				instance = TwistlockControl::ContainerInstance.new(properties)
				instance.save
				instance
			end

			def self.update
			end

			def self.remove
			end
		end
	end
end
