describe TwistlockControl::Service do
    it "can be created and added to an application" do
        service = TwistlockControl::Service.new(name: 'MyService')
        service.save
        app = TwistlockControl::Application.new(name: 'MyName')
        app.save
        app.add_service(service)
        expect(app.services).to include(service)
        app = TwistlockControl::Application.find_by_id(app.id)
        expect(app.services).to include(service)
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
end
