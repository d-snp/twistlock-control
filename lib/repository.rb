module TwistlockControl
	class Repository
		def self.table_name
			raise "#{self.class.name} should override table_name but does not"
		end

		def self.table
			TwistlockControl.database.table(table_name)
		end

		def self.save(attributes)
			with_connection do |conn|
				table.get(attributes[:id]).replace(attributes).run(conn)
			end
		end

		def self.find_by_id(id)
			with_connection do |conn|
				table.get(id).run(conn)	
			end
		end

		def self.remove(id)
			with_connection do |conn|
				table.get(id).delete.run(conn)
			end
		end

		def self.all
			with_connection do |conn|
				table.run(conn)
			end
		end

		def self.with_connection
			TwistlockControl.with_connection do |conn|
				yield conn
			end
		end

		def self.create_table
			with_connection do |conn|
				TwistlockControl.database.table_create(table_name).run(conn)
			end
		rescue RethinkDB::RqlRuntimeError
		end
	end
end
