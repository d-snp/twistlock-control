module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Provisioning service instances on provisioners
		module ContainerInstance
			class << self
				# Provision takes a ContainerConfiguration and when
				# it is done provisioning it will notify the ContainerConfiguration
				# of the ip address and container id of the provisioned container.
				def add(container_configuration)
					# TODO: figure out how to have internal actions like provisioning
					# without polluting the entities with logic
					provisioner = container_configuration.provisioner.api
					properties = provisioner.provision_container(container_configuration)
					instance = TwistlockControl::ContainerInstance.new(properties)
					instance.save
					instance
				end

				def update
				end

				def remove
				end
			end
		end
	end
end
