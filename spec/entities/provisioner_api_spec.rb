require 'spec_helper'

module TwistlockControl
	describe ProvisionerAPI do
		attr_reader :api
		before :all do
			@api = ProvisionerAPI.new("localhost:3000")
		end
		describe '#container_description' do
			before :all do
				stub_request(:get, api.url + '/templates/redis').to_return(:body => {
					name: 'redis',
					description: 'a description'
				}.to_json)
			end
			it "should connect to the given address request the container description" do
				result = api.container_description("redis")
				expect(result['name']).to eq("redis")
			end
		end

		describe '#download_container' do
			it 'should issue a download container request to the api'
		end
	end
end
