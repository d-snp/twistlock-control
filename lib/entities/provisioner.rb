require 'digest'

module TwistlockControl
	class Provisioner < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String
		attribute :url, String
		attribute :local, Boolean

		def self.local
			if attrs = ProvisionerRepository.find_by_attributes(local: true)
				new(attrs)
			end
		end

		def get_container_description(url)
		end

		def generate_id
			Digest::SHA256.hexdigest(url)
		end

		def save
			ProvisionerRepository.save(self.attributes)
		end

		def remove
			ProvisionerRepository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = ProvisionerRepository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.all()
			ProvisionerRepository.all.map {|a| new(a) }
		end
	end
end
