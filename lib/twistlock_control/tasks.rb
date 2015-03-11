require 'twistlock_control'
require 'twistlock_control/admin'

task :create_database do
	puts 'Setting up database..'
	TwistlockControl::Admin.setup_database
	puts 'Database setup done'
end
