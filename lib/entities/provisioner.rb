require 'digest'

module TwistlockControl
	# A provisioner is a machine capable of provisioning containers
	class Provisioner < PersistedEntity
		repository RethinkDBRepository['provisioners']

		attribute :id, String, default: :generate_id
		attribute :name, String
		attribute :url, String

		# Provision takes a ContainerConfiguration and when
		# it is done provisioning it will notify the ContainerConfiguration
		# of the ip address and container id of the provisioned container.
		def provision(container_configuration)
			instance = ContainerInstance.new(api.provision_container(container_configuration))
			instance.save
			instance
		end

		def container_description(name)
			api.container_description(name)
		end

		def generate_id
			Digest::SHA256.hexdigest(url)
		end

		def api
			@api ||= ProvisionerAPI.new(url)
		end
	end
end
