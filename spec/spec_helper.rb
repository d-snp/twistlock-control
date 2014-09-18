require 'twistlock_control'
require 'webmock/rspec'

TwistlockControl.configure do |c|
	c.database_name = 'test'
end

RSpec.configure do |config|
	config.before(:all) {
		TwistlockControl::ProvisionerRepository.create_table
		TwistlockControl::ServiceRepository.create_table
		TwistlockControl::ContainerRepository.create_table
	}
	config.before(:each) {
		TwistlockControl.with_connection do |conn|
			TwistlockControl.database.table('provisioners').delete.run(conn)
			TwistlockControl.database.table('services').delete.run(conn)
			TwistlockControl.database.table('containers').delete.run(conn)
		end
	}
	config.after(:all) {
	}
	config.after(:each) {
	}
end
