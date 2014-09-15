module TwistlockControl
	class ApplicationRepository
		def self.table
			TwistlockControl.database.table('applications')
		end

		def self.save(application)
			with_connection do |conn|
				table.get(application.id).replace(application.attributes).run(conn)
			end
		end

		def self.find_by_id(id)
			with_connection do |conn|
				table.get(id).run(conn)	
			end
		end

		def self.with_connection
			TwistlockControl.with_connection do |conn|
				yield conn
			end
		end
	end
end
