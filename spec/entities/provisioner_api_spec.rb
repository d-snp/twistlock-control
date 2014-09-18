require 'spec_helper'

module TwistlockControl
	describe ProvisionerAPI do
		describe '#container_description' do
			it "should connect to the given address request the container description" do
				api = ProvisionerAPI.new("localhost:3000")
				stub_request(:get, api.url + '/templates').to_return(:body => {
					name: 'redis',
					description: 'a description'
				}.to_json)
				result = api.container_description("git@github.com:d-snp/redis-container.git")
				result
			end
		end
	end
end
