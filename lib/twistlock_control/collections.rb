module TwistlockControl
	# Collections is an interface for querying the collections
	module Collections
		class << self
			def provisioners
				Entities::Provisioner.repository.table
			end

			def services
				Entities::Service.repository.table
			end

			def service_instances
				Entities::ServiceInstance.repository.table
			end

			def container_instances
				Entities::ContainerInstance.repository.table
			end
		end
	end
end
