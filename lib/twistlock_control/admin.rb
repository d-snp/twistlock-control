module TwistlockControl
	# Module for administrative commands
	module Admin
		def self.setup_database
			begin
				create_database
			rescue
				puts 'Database already exists'
			end
			create_tables
		end

		def self.create_database
			TwistlockControl.with_connection do |conn|
				RethinkDB::RQL.new.db_create(TwistlockControl.configuration.database_name).run(conn)
			end
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
