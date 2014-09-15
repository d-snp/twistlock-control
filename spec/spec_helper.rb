require 'twistlock_control'

TwistlockControl.configure do |c|
	c.database_name = 'test'
end

RSpec::Runner.configure do |config|
	config.before(:all) {
		TwistlockControl::ApplicationRepository.create_table
		TwistlockControl::ProvisionerRepository.create_table
		TwistlockControl::ServiceRepository.create_table
	}
	config.before(:each) {
		TwistlockControl.with_connection do |conn|
			TwistlockControl.database.table('applications').delete.run(conn)
			TwistlockControl.database.table('provisioners').delete.run(conn)
			TwistlockControl.database.table('services').delete.run(conn)
		end
	}
	config.after(:all) {
	}
	config.after(:each) {
	}
end
