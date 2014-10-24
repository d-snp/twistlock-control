module TwistlockControl
	class ContainerInstanceRepository < Repository
		def self.table_name
			'container_instances'
		end
	end
end
