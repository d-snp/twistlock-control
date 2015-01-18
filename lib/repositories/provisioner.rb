module TwistlockControl
	# A repository for provisioners
	class ProvisionerRepository < Repository
		def self.table_name
			'provisioners'
		end
	end
end
