require 'spec_helper'

include TwistlockControl

describe ServiceInstance do
	def make_service
		service = Entities::CompositeService.new(name: 'MyService')
		@container = Entities::Container.new(name: 'MyContainer', url: 'someUrl')
		service.save
		@container.save
		service.service_relations[@container.name] = @container.id
		service.save
		service
	end

	describe '#serialize' do
		def make_serialized
			service = make_service
			instance = Actions::ServiceInstance.add('my-instance', service)
			instance.serialize
		end

		it 'should return a hash of attributes' do
			expect(make_serialized).to respond_to(:to_hash)
		end

		it 'should be possible to initialize from serialized' do
			serialized = make_serialized
			instance = Entities::ServiceInstance.new(serialized)
			expect(instance.configuration).to_not be(nil)
		end
	end
end
