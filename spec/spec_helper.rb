require 'simplecov'
SimpleCov.start

require 'twistlock_control'
require 'twistlock_control/admin'

require 'webmock/rspec'

TwistlockControl.configure do |c|
	c.database_name = 'twistlock_control_test'
end

RSpec.configure do |config|
	config.before(:all) do
		TwistlockControl::Admin.setup_database
	end
	config.before(:each) do
		TwistlockControl::Admin.repositories.each(&:delete_all)
	end
	config.after(:all) {}
	config.after(:each) {}
end
