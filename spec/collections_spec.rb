require 'spec_helper'

include TwistlockControl

describe Collections do
	describe 'provisioners' do
		it 'should be possible to listen for changes' do
			expect(Collections.provisioners).to respond_to(:changes)
			expect(Collections.services).to respond_to(:changes)
			expect(Collections.service_instances).to respond_to(:changes)
			expect(Collections.container_instances).to respond_to(:changes)
		end
	end
end
