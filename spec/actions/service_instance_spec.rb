require 'spec_helper'

describe TwistlockControl::Actions::ServiceInstance do
	def make_service
		service = TwistlockControl::CompositeService.new(name: 'MyService')
		@container = TwistlockControl::Container.new(name: 'MyContainer', url: 'someUrl')
		@container.save
		service.service_relations[@container.name] = @container.id
		service.save
		service
	end

	# The user creates a service instance to prepare for provisioning
	# a service
	describe 'Creating a service instance' do
		def verify_service_instance(service, instance)
			expect(instance.configuration).to be_a(TwistlockControl::CompositeConfiguration)
			expect(instance.configuration.service_id).to eq(service.id)
			verify_configurations(instance.configuration.configurations)
			true
		end

		def verify_configurations(configurations)
			expect(configurations.length).to eq(1)
			expect(configurations[0]).to be_a(TwistlockControl::ContainerConfiguration)
			expect(configurations[0].service_id).to eq(@container.id)
		end

		it 'should create a service instance that has container descriptions
		    for each container of the service template' do
			service = make_service
			instance = TwistlockControl::Actions::ServiceInstance.add('my-instance', service)
			expect(verify_service_instance(service, instance)).to be(true)
		end

		it 'should be possible to retrieve a service instance from persistent storage' do
			service = make_service
			instance = TwistlockControl::Actions::ServiceInstance.add('my-instance', service)

			instance = TwistlockControl::ServiceInstance.find_by_id(instance.id)
			expect(instance).to_not be(nil)
			expect(verify_service_instance(service, instance)).to be(true)
		end
	end
end
