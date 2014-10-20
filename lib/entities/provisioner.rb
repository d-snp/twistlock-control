require 'digest'

module TwistlockControl
	class Provisioner < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String
		attribute :url, String

		def provision(service)
			provision = lambda do |service_relation|
				if service_relation.is_a_container?
					container = service_relation.container
					api.add_container(container.name, container.url)
				else
					s = service_relation.service
					s.services.each {|sr| provision[sr]}
				end
			end

			service.services.each { |sr| provision[sr] }
		end

		def container_description(name)
			api.container_description(name)
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
