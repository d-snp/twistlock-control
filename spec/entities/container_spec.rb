require 'spec_helper'

module TwistlockControl
	describe Container do
		it "should be able to get a description" do
			lprov = Provisioner.new(url: 'someUrl', local: true)
			lprov.save
			c = Container.new(url: 'git@github.com:d-snp/redis-container.git')
			expect(c.description).to be(nil)
			c.get_description
			expect(c.description).to_not be(nil)
		end
	end
end
