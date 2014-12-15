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

		def verify_service_instance(service, instance)
			expect(instance.configuration).to be_a(TwistlockControl::CompositeConfiguration)
			expect(instance.configuration.service_id).to eq(service.id)
			expect(instance.configuration.configurations.length).to eq(1)
			expect(instance.configuration.configurations[0]).to be_a(TwistlockControl::ContainerConfiguration)
			expect(instance.configuration.configurations[0].service_id).to eq(@container.id)
			true
		end

		it "should create a service instance that has container descriptions
		    for each container of the service template" do
			service = make_service
			instance = TwistlockControl::ServiceInstance.create('my-instance',service)
			expect(verify_service_instance(service, instance)).to be(true)
		end

		it "should be possible to retrieve a service instance from persistent storage" do
			service = make_service
			instance = TwistlockControl::ServiceInstance.create('my-instance',service)
			instance.save

			instance = TwistlockControl::ServiceInstance.find_by_id(instance.id)
			expect(instance).to_not be(nil)
			expect(verify_service_instance(service, instance)).to be(true)
		end

		describe "#serialize" do
			def make_serialized
				service = make_service
				instance = TwistlockControl::ServiceInstance.create('my-instance',service)
				serialized = instance.serialize
			end

			it "should return a hash of attributes" do
				expect(make_serialized).to respond_to(:to_hash)
			end

			it "should be possible to initialize from serialized" do
				serialized = make_serialized
				instance = TwistlockControl::ServiceInstance.new(serialized)
				expect(instance.configuration).to_not be(nil)
			end
		end
	end
end
