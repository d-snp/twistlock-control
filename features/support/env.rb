require 'twistlock_control'

include TwistlockControl

Before do
	TwistlockControl.configure do |c|
		c.database_name = 'test'
	end

	ProvisionerRepository.create_table
	ServiceRepository.create_table
	ServiceInstanceRepository.create_table
	ContainerInstanceRepository.create_table
end

After do
	TwistlockControl.with_connection do |conn|
		TwistlockControl.database.table('provisioners').delete.run(conn)
		TwistlockControl.database.table('services').delete.run(conn)
		TwistlockControl.database.table('service_instances').delete.run(conn)
		TwistlockControl.database.table('container_instances').delete.run(conn)
	end
end
