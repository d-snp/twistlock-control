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

	describe '#serialize' do
		def make_serialized
			service = make_service
			instance = TwistlockControl::Actions::ServiceInstance.add('my-instance', service)
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
