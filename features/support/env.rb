require 'twistlock_control'

require 'cucumber/rspec/doubles'

include TwistlockControl

def repositories
	%w(provisioners services service_instances container_instances)
		.map { |n| TwistlockControl::RethinkDBRepository[n] }
end

Before do
	TwistlockControl.configure do |c|
		c.database_name = 'test'
	end

	repositories.each(&:create_table)
end

After do
	repositories.each(&:delete_all)
end
