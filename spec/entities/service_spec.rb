require 'spec_helper'
require 'entities/shared_service_specs'

describe TwistlockControl::Service do
    it_should_behave_like "a service"
    it "can be created and added to an service" do
        service = TwistlockControl::Service.new(name: 'MyService')
        service.save
        app = TwistlockControl::Service.new(name: 'MyName')
        app.save
        app.add_service(service)
        expect(app.services.map(&:service)).to include(service)
        app = TwistlockControl::Service.find_by_id(app.id)
        expect(app.services.map(&:service)).to include(service)
    end

    it "can have containers added to it" do
        container = TwistlockControl::Container.new(name: 'MyContainer', url: 'someUrl')
        container.save
        app = TwistlockControl::Service.new(name: 'MyName')
        app.save
        app.add_container(container)
        app = TwistlockControl::Service.find_by_id(app.id)
        expect(app.services.map(&:container)).to include(container)
    end

    it "can find a bunch of services by ids" do
        ids = []
        (1..3).each do |i|
            service = TwistlockControl::Service.new(name: "Service#{i}")
            ids << service.id
            service.save
        end
        services = TwistlockControl::Service.find_with_ids(ids)
        expect(services.length).to be(3)
    end

    it "can be initialized from its attributes" do
        app = TwistlockControl::Service.new(name: 'MyName')
        expect(app.respond_to? :name).to be(true)
        expect(app.name).to eq('MyName')
    end

    it "can be persisted and retrieved from the database" do
        app = TwistlockControl::Service.new(name: 'MyName')
        app.save
        retrieved = TwistlockControl::Service.find_by_id(app.id)
        expect(retrieved).to eq(app)
    end

    it "can get a list of services" do
        (1..3).each do |i|
            app = TwistlockControl::Service.new(name: "App#{i}")
            app.save
        end
        retrieved = TwistlockControl::Service.all
        expect(retrieved.length).to eq(3)
    end

    it "can remove services" do
        app = TwistlockControl::Service.new(name: 'MyName')
        app.save
        app.remove
        app = TwistlockControl::Service.find_by_id(app.id)
        expect(app).to be_nil
    end

    it "should not somehow get confused with other tables" do
        app = TwistlockControl::Service.new(name: 'MyName')
        app.save
        prov = TwistlockControl::Provisioner.new(name: 'MyName', url: "someUrl")
        prov.save
        expect(TwistlockControl::Service.all.length).to be(1)
        expect(TwistlockControl::Provisioner.all.length).to be(1)
    end
end
