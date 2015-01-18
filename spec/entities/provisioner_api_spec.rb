require 'spec_helper'

include TwistlockControl

describe ProvisionerAPI do
	attr_reader :api
	before :all do
		@api = ProvisionerAPI.new('http://localhost:3000')
	end
	describe '#container_description' do
		before :all do
			stub_request(:get, api.url + '/templates/redis').to_return(body: {
				name: 'redis',
				description: 'a description'
			}.to_json)
		end
		it 'should connect to the given address request the container description' do
			result = api.container_description('redis')
			expect(result['name']).to eq('redis')
		end
	end

	describe '#add_container' do
		before :all do
			stub_request(:post, api.url + '/templates').to_return do
				{ body: { status: 'ok' }.to_json }
			end
		end

		it 'should issue an add container request to the api' do
			result = api.add_container('redis', 'git@github.com:d-snp/redis-container.git')
			expect(result['status']).to eq('ok')
		end
	end
end
