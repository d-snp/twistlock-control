module TwistlockControl
	class ServiceRepository < Repository
		def self.table_name
			'services'
		end

		def self.containers
			find_by_attributes(service_type: :container)
		end
	end
end