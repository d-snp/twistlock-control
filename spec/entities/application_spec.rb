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

    it "can get a list of applications" do
        (1..3).each do |i|
            app = TwistlockControl::Application.new(name: "App#{i}")
            app.save
        end
        retrieved = TwistlockControl::Application.all
        expect(retrieved.length).to eq(3)
    end

    it "can remove applications" do
        app = TwistlockControl::Application.new(name: 'MyName')
        app.save
        app.remove
        app = TwistlockControl::Application.find_by_id(app.id)
        expect(app).to be_nil
    end
end
