require 'spec_helper'
require 'entities/shared_service_specs'

describe TwistlockControl::CompositeService do
    it_should_behave_like 'a service'

    it 'can be created and added to an service' do
        service = TwistlockControl::CompositeService.new(name: 'MyService')
        service.save
        app = TwistlockControl::CompositeService.new(name: 'MyName')
        app.save
        app.add_service(service)
        expect(app.services).to include(service)
        app = TwistlockControl::CompositeService.find_by_id(app.id)
        expect(app.services).to include(service)
    end

    it 'can have containers added to it' do
        container = TwistlockControl::Container.new(name: 'MyContainer', url: 'someUrl')
        container.save
        app = TwistlockControl::CompositeService.new(name: 'MyName')
        app.save
        app.add_service(container)
        app = TwistlockControl::CompositeService.find_by_id(app.id)
        expect(app.services).to include(container)
    end

    it 'can link two containers together' do
        container = TwistlockControl::Container.new(name: 'redis', url: 'git@github.com:d-snp/redis-container.git')
        container.save
        container2 = TwistlockControl::Container.new(name: 'rails', url: 'git@github.com:d-snp/rails-container.git')
        container2.save
        app = TwistlockControl::CompositeService.new(name: 'WebApp')
        app.save
        app.add_service(container)
        app.add_service(container2)
        app.link(container, 'redis', container2, 'redis')
        app = TwistlockControl::CompositeService.find_by_id(app.id)

        link = app.links[0]
        expect(link).to_not be_nil
        expect(link.provider_name).to eq(container.name)
        expect(link.consumer_name).to eq(container2.name)
    end

    it 'can find a bunch of services by ids' do
        ids = []
        (1..3).each do |i|
            service = TwistlockControl::CompositeService.new(name: "Service#{i}")
            ids << service.id
            service.save
        end
        services = TwistlockControl::CompositeService.find_with_ids(ids)
        expect(services.length).to be(3)
    end

    it 'can be initialized from its attributes' do
        app = TwistlockControl::CompositeService.new(name: 'MyName')
        expect(app.respond_to? :name).to be(true)
        expect(app.name).to eq('MyName')
    end

    it 'can be persisted and retrieved from the database' do
        app = TwistlockControl::CompositeService.new(name: 'MyName')
        app.save
        retrieved = TwistlockControl::CompositeService.find_by_id(app.id)
        expect(retrieved).to eq(app)
    end

    it 'can get a list of services' do
        (1..3).each do |i|
            app = TwistlockControl::CompositeService.new(name: "App#{i}")
            app.save
        end
        retrieved = TwistlockControl::CompositeService.all
        expect(retrieved.length).to eq(3)
    end

    it 'can remove services' do
        app = TwistlockControl::CompositeService.new(name: 'MyName')
        app.save
        app.remove
        app = TwistlockControl::CompositeService.find_by_id(app.id)
        expect(app).to be_nil
    end

    it 'should not somehow get confused with other tables' do
        app = TwistlockControl::CompositeService.new(name: 'MyName')
        app.save
        prov = TwistlockControl::Provisioner.new(name: 'MyName', url: 'someUrl')
        prov.save
        expect(TwistlockControl::CompositeService.all.length).to be(1)
        expect(TwistlockControl::Provisioner.all.length).to be(1)
    end

    describe 'instances' do 
        before :each do
            @container = TwistlockControl::Container.new(name: 'redis', url: 'git@github.com:d-snp/redis-container.git')
            @container.save
            @container2 = TwistlockControl::Container.new(name: 'rails', url: 'git@github.com:d-snp/rails-container.git')
            @container2.save
            @app = TwistlockControl::CompositeService.new(name: 'WebApp')
            @app.save
            @app.add_service(@container)
        end

        it 'can expose a port exposed by a service' do
            # expose the redis provided service of the the redis container as 'redis'
            @app.expose('redis', 'redis' => 'redis')
            app = TwistlockControl::CompositeService.find_by_id(@app.id)
            exposed = app.provided_services['redis']
            expect(exposed).to_not be_nil
            expect(exposed).to eq('redis' => 'redis')
        end
    end
end
