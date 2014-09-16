module TwistlockControl
	class ContainerRepository < Repository
		def self.table_name
			'containers'
		end
	end
end
