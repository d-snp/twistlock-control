require 'spec_helper'

describe TwistlockControl::Application do
    it "can be initialized from its attributes" do
        app = TwistlockControl::Application.new(name: 'MyName')
        expect(app.respond_to? :name).to be(true)
        expect(app.name).to eq('MyName')
    end
end
