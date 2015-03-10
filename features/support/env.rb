require 'twistlock_control'
require 'twistlock_control/admin'

require 'cucumber/rspec/doubles'

include TwistlockControl

Before do
	TwistlockControl.configure do |c|
		c.database_name = 'test'
	end

	Admin.setup_database
end

After do
	Admin.repositories.each(&:delete_all)
end
