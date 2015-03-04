module TwistlockControl
	# Some helper functions around access to RethinkDB collections
	class RethinkDBRepository
		def self.[](table_name)
			new(table_name)
		end

		def initialize(table_name)
			@table_name = table_name
		end

		attr_accessor :table_name

		def table
			TwistlockControl.database.table(table_name)
		end

		def save(attributes)
			with_connection do |conn|
				table.get(attributes[:id]).replace(attributes).run(conn)
			end
		end

		def find_by_id(id)
			with_connection do |conn|
				table.get(id).run(conn)
			end
		end

		def find_by_attributes(attrs)
			with_connection do |conn|
				table.filter(attrs).limit(1).run(conn).first
			end
		end

		def find_with_ids(ids)
			with_connection do |conn|
				table.get_all(*ids).run(conn)
			end
		end

		def remove(id)
			with_connection do |conn|
				table.get(id).delete.run(conn)
			end
		end

		def all
			with_connection do |conn|
				table.run(conn)
			end
		end

		def with_connection
			TwistlockControl.with_connection do |conn|
				yield conn
			end
		end

		def create_table
			with_connection do |conn|
				TwistlockControl.database.table_create(table_name).run(conn)
			end
		rescue RethinkDB::RqlRuntimeError
			nil
		end

		def delete_all
			with_connection do |conn|
				table.delete.run(conn)
			end
		end
	end
end
