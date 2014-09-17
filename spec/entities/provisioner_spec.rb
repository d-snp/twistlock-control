require 'spec_helper'

describe TwistlockControl::Provisioner do
    it "can be initialized from its attributes" do
        prov = TwistlockControl::Provisioner.new(name: 'MyName', url: 'url')
        expect(prov.respond_to? :name).to be(true)
        expect(prov.name).to eq('MyName')
    end

    it "can be persisted and retrieved from the database" do
        prov = TwistlockControl::Provisioner.new(name: 'MyName', url: 'url')
        prov.save
        retrieved = TwistlockControl::Provisioner.find_by_id(prov.id)
        expect(retrieved).to eq(prov)
    end

    it "can get a list of provisioners" do
        (1..3).each do |i|
            prov = TwistlockControl::Provisioner.new(name: "Prov#{i}", url: "url#{i}")
            prov.save
        end
        retrieved = TwistlockControl::Provisioner.all
        expect(retrieved.length).to eq(3)
    end

    it "can remove provisioners" do
        prov = TwistlockControl::Provisioner.new(name: 'MyName', url: 'url')
        prov.save
        prov.remove
        prov = TwistlockControl::Provisioner.find_by_id(prov.id)
        expect(prov).to be_nil
    end
end
