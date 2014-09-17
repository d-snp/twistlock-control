require 'spec_helper'

module TwistlockControl
	describe Container do
		it "should be able to get a description" do
			lprov = Provisioner.new(url: 'someUrl', local: true)
			c = Container.new(url: 'git@github.com:d-snp/redis-container.git')
			expect(Provisioner).to receive(:local).and_return(lprov)
			expect(lprov).to receive(:container_description).and_return(
				name: 'redis',
				description: 'Redis cache database'
			)
			c.get_description
			expect(c.description).to_not be(nil)
			expect(c.description.name).to eq("redis")
		end
	end
end
