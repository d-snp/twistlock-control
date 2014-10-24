require 'spec_helper'

describe TwistlockControl::ServiceInstance do
	# The user creates a service instance to prepare for provisioning
	# a service
	describe "Creating a service instance" do
		def make_service
			service = TwistlockControl::Service.new(name: 'MyService')
			container = TwistlockControl::Container.new(name: 'MyContainer', url: 'someUrl')
			service.save
			container.save
			service.add_container(container)
			service
		end

		it "should create a service instance that has container descriptions
		    for each container of the service template" do
			service = make_service
			instance = TwistlockControl::ServiceInstance.new('my-instance',service)
			expect(instance.containers.length).to eq(1)
			container_description = instance.containers[0]
			expect(container_description.container_id).to eq(service.containers[0].id)
		end
	end
end
