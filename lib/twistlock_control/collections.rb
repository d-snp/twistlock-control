module TwistlockControl
	# Collections is an interface for querying the collections
	module Collections
		class << self
			def provisioners
				Provisioner.repository.table
			end

			def services
				Service.repository.table
			end

			def service_instances
				ServiceInstance.repository.table
			end

			def container_instances
				ContainerInstance.repository.table
			end
		end
	end
end
