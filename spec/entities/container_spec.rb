require 'spec_helper'

module TwistlockControl
	describe Container do
		attr_reader :lprov, :container

		before :each do
			@lprov = Provisioner.new(url: 'someUrl', local: true)
			@container = Container.new(name: 'redis', url: 'git@github.com:d-snp/redis-container.git')
			allow(Provisioner).to receive(:local).and_return(lprov)
		end

		it "should be able to get a description" do
			expect(lprov).to receive(:container_description).with('redis').and_return(
				name: 'redis',
				description: 'Redis cache database'
			)
			container.get_description
			expect(container.description).to_not be(nil)
			expect(container.description.name).to eq("redis")
		end
	end
end
