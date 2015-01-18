module TwistlockControl
	# A repository for storing service instances.
	class ServiceInstanceRepository < Repository
		def self.table_name
			'service_instances'
		end
	end
end
