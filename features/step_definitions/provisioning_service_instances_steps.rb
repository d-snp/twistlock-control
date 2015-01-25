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
	@service_instance = @service.create_instance('my-instance')
end

Then(/^(?:a|the) user should be presented with a configurable representation of the service$/) do
	@container_configuration = @service_instance.container_configurations.first
end

When(/^(?:a|the) user configures the service instance$/) do
	@container_configuration.provisioner = @provisioner
end

When(/^(?:a|the) user gives the provision command$/) do
	@service_instance.provision
end

Then(/^(?:a|the) provisioner should be sent a provisioning command$/) do
	pending # express the regexp above with the code you wish you had
end
