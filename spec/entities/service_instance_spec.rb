require 'spec_helper'

describe TwistlockControl::ServiceInstance do
	# The user creates a service instance to prepare for provisioning
	# a service
	describe "Creating a service instance" do
		def make_service
			service = TwistlockControl::CompositeService.new(name: 'MyService')
			@container = TwistlockControl::Container.new(name: 'MyContainer', url: 'someUrl')
			service.save
			@container.save
			service.add_service(@container)
			service
		end

		it "should create a service instance that has container descriptions
		    for each container of the service template" do
			service = make_service
			instance = TwistlockControl::ServiceInstance.create('my-instance',service)
			
			expect(instance.configuration).to be_a(TwistlockControl::CompositeConfiguration)
			expect(instance.configuration.service_id).to eq(service.id)
			expect(instance.configuration.configurations.length).to eq(1)
			expect(instance.configuration.configurations[0]).to be_a(TwistlockControl::ContainerConfiguration)
			expect(instance.configuration.configurations[0].service_id).to eq(@container.id)
		end
	end
end
