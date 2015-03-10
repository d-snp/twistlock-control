require 'spec_helper'

include TwistlockControl

describe Actions::Provisioner do
	describe '.add' do
		it 'can be initialized from its attributes' do
			prov = Actions::Provisioner.add(name: 'MyName', url: 'url')
			expect(prov).to_not be_nil
			expect(prov.name).to eq('MyName')
		end

		it 'can be persisted and retrieved from the database' do
			prov = Actions::Provisioner.add(name: 'MyName', url: 'url')
			retrieved = Entities::Provisioner.find_by_id(prov.id)
			expect(retrieved).to eq(prov)
		end
	end

	describe '.update' do
		it 'updates a provisioner and persists it' do
			prov = Actions::Provisioner.add(name: 'MyName', url: 'url')
			Actions::Provisioner.update(prov.id, name: 'MyNewName')
			prov = Entities::Provisioner.find_by_id(prov.id)
			expect(prov.name).to eq('MyNewName')
		end
	end

	describe '.remove' do
		it 'removes provisioners' do
			prov = Actions::Provisioner.add(name: 'MyName', url: 'url')
			prov.remove
			prov = Entities::Provisioner.find_by_id(prov.id)
			expect(prov).to be_nil
		end
	end
end
