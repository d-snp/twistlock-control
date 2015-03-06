require 'spec_helper'

describe TwistlockControl::Actions::Container do
	attr_reader :container

	before :each do
		dir = Dir.pwd + '/../redis-container'
		@container = TwistlockControl::Container.new(name: 'redis', url: dir)
	end

	describe 'synchronizing the description' do
		it 'should be able to get a description' do
			TwistlockControl::Actions::Container.synchronize_description(container)
			expect(container.description).to be_a(ContainerDescription)
			expect(container.description.name).to eq('redis')
		end
	end
end
