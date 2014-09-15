require 'twistlock_control'

TwistlockControl.configure do |c|
	c.database_name = 'test'
end


Spec::Runner.configure do |config|
	config.before(:all) {
		TwistlockControl.with_connection do |conn|
			RethinkDB::RQL.new().db_drop(TwistlockControl.database_name)
		end
	}
	config.before(:each) {
		TwistlockControl.with_connection do |conn|
			TwistlockControl.database.table_create('applications').run(conn)
		end
	}
	config.after(:all) {
		TwistlockControl.with_connection do |conn|
			RethinkDB::RQL.new().db_drop(TwistlockControl.database_name)
		end
	}
	config.after(:each) {
		TwistlockControl.with_connection do |conn|
			TwistlockControl.database.table_drop('applications').run(conn)
		end
	}
end
