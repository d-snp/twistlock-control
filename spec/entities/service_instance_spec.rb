require 'spec_helper'

describe TwistlockControl::ServiceInstance do
	def make_service
		service = TwistlockControl::CompositeService.new(name: 'MyService')
		@container = TwistlockControl::Container.new(name: 'MyContainer', url: 'someUrl')
		service.save
		@container.save
		service.add_service(@container)
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
			instance = service.create_instance('my-instance')
			expect(verify_service_instance(service, instance)).to be(true)
		end

		it 'should be possible to retrieve a service instance from persistent storage' do
			service = make_service
			instance = service.create_instance('my-instance')
			instance.save

			instance = TwistlockControl::ServiceInstance.find_by_id(instance.id)
			expect(instance).to_not be(nil)
			expect(verify_service_instance(service, instance)).to be(true)
		end
	end

	# So the idea is that we create a service instance and that service
	# instance will have a tree of configuration objects, one leaf for
	# each container. We will iterate over the containers and ask the user to assign a provider for each container.
	#
	# After that the system will attempt to provision all the containers. When
	# a container comes online the system will look through its desire links
	# and establish them if possible.

	describe 'Setting an instance up for provisioning' do
		pending 'ContainerConfiguration should have its own repository'
	end

	describe '#serialize' do
		def make_serialized
			service = make_service
			instance = service.create_instance('my-instance')
			instance.serialize
		end

		it 'should return a hash of attributes' do
			expect(make_serialized).to respond_to(:to_hash)
		end

		it 'should be possible to initialize from serialized' do
			serialized = make_serialized
			instance = TwistlockControl::ServiceInstance.new(serialized)
			expect(instance.configuration).to_not be(nil)
		end
	end
end
