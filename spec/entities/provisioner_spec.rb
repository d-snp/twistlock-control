require 'spec_helper'

include TwistlockControl

describe Entities::Provisioner do
	it 'can provision a container instance' do
		prov = Entities::Provisioner.new(name: 'MyName', url: 'url')

		container = Entities::Container.new(name: 'MyContainer', url: 'someUrl')
		container.save

		service_instance = Actions::ServiceInstance.add('myServiceInstance', container)

		configuration = service_instance.container_configurations.first
		configuration.provisioner = prov

		api = double(TwistlockControl::ProvisionerAPI)
		expect(prov).to receive(:api).and_return(api)
		expect(api).to receive(:provision_container)
			.with(configuration)
			.and_return(container_id: 'abcd', ip_address: '127.0.0.1')

		Actions::ContainerInstance.add(configuration)
		service_instance.save
	end

	it 'can be initialized from its attributes' do
		prov = Entities::Provisioner.new(name: 'MyName', url: 'url')
		expect(prov.respond_to? :name).to be(true)
		expect(prov.name).to eq('MyName')
	end

	it 'can be persisted and retrieved from the database' do
		prov = Entities::Provisioner.new(name: 'MyName', url: 'url')
		prov.save
		retrieved = Entities::Provisioner.find_by_id(prov.id)
		expect(retrieved).to eq(prov)
	end

	it 'can get a list of provisioners' do
		(1..3).each do |i|
			prov = Entities::Provisioner.new(name: "Prov#{i}", url: "url#{i}")
			prov.save
		end
		retrieved = Entities::Provisioner.all
		expect(retrieved.length).to eq(3)
	end

	it 'can remove provisioners' do
		prov = Entities::Provisioner.new(name: 'MyName', url: 'url')
		prov.save
		prov.remove
		prov = Entities::Provisioner.find_by_id(prov.id)
		expect(prov).to be_nil
	end
end
