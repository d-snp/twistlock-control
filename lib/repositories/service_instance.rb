module TwistlockControl
	class ServiceInstanceRepository < Repository
		def self.table_name
			'service_instances'
		end
	end
end
