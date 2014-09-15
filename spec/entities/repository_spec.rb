require 'spec_helper'

describe TwistlockControl::Repository do
    it "should be able to find documents with ids" do
        app = {
            id: 'my-app',
            name: 'My App'
        }
        TwistlockControl::ApplicationRepository.save(app)
        expect(TwistlockControl::ApplicationRepository.find_with_ids([app[:id]]).length).to be(1)
    end
end
