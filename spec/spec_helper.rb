require 'simplecov'
SimpleCov.start

require 'twistlock_control'
require 'webmock/rspec'

TwistlockControl.configure do |c|
	c.database_name = 'test'
end

def repositories
	%w(provisioners services service_instances container_instances)
		.map { |n| TwistlockControl::RethinkDBRepository[n] }
end

RSpec.configure do |config|
	config.before(:all) do
		repositories.each(&:create_table)
	end
	config.before(:each) do
		repositories.each(&:delete_all)
	end
	config.after(:all) {}
	config.after(:each) {}
end
