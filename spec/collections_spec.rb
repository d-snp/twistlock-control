require 'spec_helper'

describe TwistlockControl::Collections do
	describe 'provisioners' do
		it 'should be possible to listen for changes' do
			expect(TwistlockControl::Collections.provisioners).to respond_to(:changes)
			expect(TwistlockControl::Collections.services).to respond_to(:changes)
			expect(TwistlockControl::Collections.service_instances).to respond_to(:changes)
			expect(TwistlockControl::Collections.container_instances).to respond_to(:changes)
		end
	end
end
