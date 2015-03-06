Given(/^(?:a|the) user has defined a service$/) do
	dir = Dir.pwd + '/../redis-container'
	@service = Container.new(name: 'redis', url: dir)
	@service.save
end

Given(/^a provisioner is configured$/) do
	@provisioner = Provisioner.new(name: 'my-provisioner', url: 'localhost')
	@provisioner.save
end

Given(/^(?:a|the) user has created an instance of that service$/) do
	@service_instance = TwistlockControl::Actions::ServiceInstance.add('my-instance', @service)
end

Then(/^(?:a|the) user should be presented with a configurable representation of the service$/) do
	@container_configuration = @service_instance.container_configurations.first
end

When(/^(?:a|the) user configures the service instance$/) do
	@container_configuration.provisioner = @provisioner
end

When(/^(?:a|the) user gives the provision command$/) do
	api_double = double
	expect(api_double).to receive(:provision_container).and_return({})
	expect(@provisioner).to receive(:api).and_return(api_double)
	TwistlockControl::Actions::ContainerInstance.add(@container_configuration)
end

Then(/^a container instance should be provisioned$/) do
	expect(ContainerInstance.all.length).to equal(1)
end
