require_relative 'entity'

%w(
	provisioning_configuration
	service
	provisioner
	composite_service
	service_instance
	container
	container_instance
).each { |entity| require_relative("entities/#{entity}") }
