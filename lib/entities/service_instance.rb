module TwistlockControl
	class ContainerDescription < Entity
		attribute :container_id
	end

	class ServiceInstance < Entity
		attribute :id, String
		attribute :containers, [ContainerDescription]

		def initialize(name, service)
			@id = service.id + '-instance-' + name.downcase.gsub(' ','-')
			@containers = []

			service.containers.each do |container|
				containers.push(ContainerDescription.new(container_id: container.id))
			end
		end
	end
end
