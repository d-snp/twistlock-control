shared_examples_for "a service" do
    describe "service exposed resources" do
        before :each do
            @container = TwistlockControl::Container.new(name: 'redis', url: 'git@github.com:d-snp/redis-container.git')
            @container.save
            @app = TwistlockControl::Service.new(name: 'Redis')
            @app.save
            @app.add_container(@container)
        end

        it "can expose a port exposed by a service" do
            # expose the redis provided service of the the redis container as 'redis'
            @app.expose('redis', 'redis' => 'redis')
            app = TwistlockControl::Service.find_by_id(@app.id)
            exposed = app.provided_services['redis']
            expect(exposed).to_not be_nil
            expect(exposed).to eq('redis' => 'redis')
        end

        it "can link two containers together" do
            @app.link({'redis' => 'redis'}, {'other_app' => 'redis'})
            app = TwistlockControl::Service.find_by_id(@app.id)
            link = app.links[0]
            expect(link).to_not be_nil
            expect(link).to eq([{'redis' => 'redis'}, {'other_app' => 'redis'}])
        end
    end
end
