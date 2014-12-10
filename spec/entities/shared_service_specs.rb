shared_examples_for "a service" do
    describe "service exposed resources" do
        before :each do
            @container = TwistlockControl::Container.new(name: 'redis', url: 'git@github.com:d-snp/redis-container.git')
            @container.save
            @container2 = TwistlockControl::Container.new(name: 'rails', url: 'git@github.com:d-snp/rails-container.git')
            @container2.save
            @app = TwistlockControl::CompositeService.new(name: 'WebApp')
            @app.save
            @app.add_service(@container)
        end

        it "can expose a port exposed by a service" do
            # expose the redis provided service of the the redis container as 'redis'
            pending "Implement port exposing properly"
            @app.expose('redis', 'redis' => 'redis')
            app = TwistlockControl::CompositeService.find_by_id(@app.id)
            exposed = app.provided_services['redis']
            expect(exposed).to_not be_nil
            expect(exposed).to eq('redis' => 'redis')
        end
    end
end
