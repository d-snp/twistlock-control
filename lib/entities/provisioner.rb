require 'digest'

module TwistlockControl
	class Provisioner < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String
		attribute :url, String
		attribute :local, Boolean

		def self.local
			if attrs = repository.find_by_attributes(local: true)
				new(attrs)
			end
		end

		def container_description(url)
			api.container_description(url)
		end

		def generate_id
			Digest::SHA256.hexdigest(url)
		end

		def save
			repository.save(self.attributes)
		end

		def remove
			repository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = repository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.all()
			repository.all.map {|a| new(a) }
		end

		private
		def api
			@api ||= ProvisionerAPI.new(url)
		end

		def repository
			ProvisionerRepository
		end

		def self.repository
			ProvisionerRepository
		end
	end
end