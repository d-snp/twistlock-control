require 'spec_helper'

describe TwistlockControl::Actions::Container do
	attr_reader :container

	describe 'adding a container' do
		it 'should persist the container and synchronize its description' do
			dir = Dir.pwd + '/../redis-container'
			container = TwistlockControl::Actions::Container.add(name: 'redis', url: dir)

			container = TwistlockControl::Container.find_by_id(container.id)
			expect(container.url).to eq(dir)
			expect(container.description).to be_a(ContainerDescription)
			expect(container.description.name).to eq('redis')
		end
	end
end
