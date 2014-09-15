module TwistlockControl
	class ProvisionerRepository < Repository
		def self.table_name
			'provisioners'
		end
	end
end
