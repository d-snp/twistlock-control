require 'twistlock_control'
require 'webmock/rspec'

TwistlockControl.configure do |c|
	c.database_name = 'test'
end

RSpec.configure do |config|
	config.before(:all) do
		TwistlockControl::ProvisionerRepository.create_table
		TwistlockControl::ServiceRepository.create_table
		TwistlockControl::ServiceInstanceRepository.create_table
		TwistlockControl::ContainerInstanceRepository.create_table
	end
	config.before(:each) do
		TwistlockControl.with_connection do |conn|
			TwistlockControl.database.table('provisioners').delete.run(conn)
			TwistlockControl.database.table('services').delete.run(conn)
			TwistlockControl.database.table('service_instances').delete.run(conn)
			TwistlockControl.database.table('container_instances').delete.run(conn)
		end
	end
	config.after(:all) {}
	config.after(:each) {}
end
