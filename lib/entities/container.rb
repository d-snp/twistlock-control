require 'digest'
require 'securerandom'
require 'fileutils'
require 'yaml'

module TwistlockControl
	class RelatedServiceDescription < Entity
		attribute :port
		attribute :description
	end

	class ContainerDescription < Entity
		attribute :name, String
		attribute :description, String
		attribute :provided_services, Hash[String => RelatedServiceDescription]
		attribute :consumed_services, Hash[String => RelatedServiceDescription]

		def self.fetch(container)
			nonce = SecureRandom.hex[0..7]
			dirname = "/tmp/#{container.name}-#{nonce}"
			FileUtils.mkdir_p dirname
			Dir.chdir(dirname) do
				`git clone -n --depth=1 #{container.url} .`
				`git checkout HEAD twistlock.yml`
				result = `cat twistlock.yml && rm -rf #{dirname}`
				new(YAML.load(result))
			end
		end

		def serialize
			provided_services = (provided_services || {}).inject({}) {|r,(k,v)| r[k] = v.attributes }
			consumed_services = (consumed_services || {}).inject({}) {|r,(k,v)| r[k] = v.attributes }
			attributes.dup.merge!(
				:provided_services => provided_services,
				:consumed_services => consumed_services
			)
		end
	end
	
	# A container is a service that can be provisioned on a Twistlock provisioner node.
	class Container < Service
		attribute :service_type, Symbol, :default => :container
		attribute :id, String, :default => :generate_id
		attribute :url, String
		attribute :name, String
		attribute :description, ContainerDescription

		# The network services provided by this service. Each service is
		# identified with a name, for example: offers HTTP on port 80.
		def provided_services
			description.provided_services
		end

		# The service can depend on any other services. For example it might
		# require a MySQL service to be linked in on port 3047.
		def consumed_services
			description.consumed_services
		end

		def generate_id
			Digest::SHA256.hexdigest(url)
		end

		def synchronize_description
			@description = ContainerDescription.fetch(self)
			save
		end

		def serialize
			attrs = self.attributes.dup.merge!(
				:description => description ? description.serialize : nil
			)
		end

		def save
			ServiceRepository.save(serialize)
		end

		def remove
			ServiceRepository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = ServiceRepository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.find_with_ids(ids)
			ServiceRepository.find_with_ids(ids).map {|a| new(a) }
		end

		def self.all()
			ServiceRepository.containers.map {|a| new(a) }
		end
	end
end
