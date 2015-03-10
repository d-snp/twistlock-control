require 'twistlock_control'
require 'twistlock_control/admin'

task :create_database do
	TwistlockControl::Admin.setup_database
end
