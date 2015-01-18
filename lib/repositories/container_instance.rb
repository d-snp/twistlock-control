module TwistlockControl
	# A repository for container instances
	class ContainerInstanceRepository < Repository
		def self.table_name
			'container_instances'
		end
	end
end
