module TwistlockControl
	# A Repository is an interface to a persistant storage
	# The current implementation is very specific to rethinkdb,
	# if we would extend to support other storage we would move
	# this code into a class called "RethinkDBRepository" that
	# extends from this class.
	class Repository
		def self.table_name
			fail "#{self.class.name} should override table_name but does not"
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

		def self.find_by_attributes(attrs)
			with_connection do |conn|
				table.filter(attrs).limit(1).run(conn).first
			end
		end

		def self.find_with_ids(ids)
			with_connection do |conn|
				table.get_all(*ids).run(conn)
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
			nil
		end
	end
end
