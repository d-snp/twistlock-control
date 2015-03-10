module TwistlockControl
	# Module for administrative commands
	module Admin
		def self.setup_database
			create_tables
		end

		def self.create_tables
			repositories.each(&:create_table)
		end

		def self.repositories
			%w(provisioners services service_instances container_instances)
				.map { |n| RethinkDBRepository[n] }
		end
	end
end
