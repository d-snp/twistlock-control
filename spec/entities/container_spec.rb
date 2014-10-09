require 'spec_helper'
require 'entities/shared_service_specs'

module TwistlockControl
	describe Container do
		it_should_behave_like "a service"

		attr_reader :container

		before :each do
			dir = Dir.pwd + '/../redis-container'
			@container = Container.new(name: 'redis', url: dir)
		end

		it "should be able to get a description" do
			container.get_description
			expect(container.description).to be_a(ContainerDescription)
			expect(container.description.name).to eq("redis")
		end
	end
end
