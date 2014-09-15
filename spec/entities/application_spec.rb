require 'spec_helper'

describe TwistlockControl::Application do
    it "can be initialized from its attributes" do
        app = TwistlockControl::Application.new(name: 'MyName')
        expect(app.respond_to? :name).to be(true)
        expect(app.name).to eq('MyName')
    end

    it "can be persisted and retrieved from the database" do
        app = TwistlockControl::Application.new(name: 'MyName')
        app.save
        retrieved = TwistlockControl::Application.find_by_id(app.id)
        expect(retrieved).to eq(app)
    end
end
