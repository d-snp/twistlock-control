require 'digest'
require 'securerandom'
require 'fileutils'
require 'yaml'

module TwistlockControl
	# A container is a service that can be provisioned on a Twistlock provisioner node.
	class Container < Service
		attribute :service_type, Symbol, :default => :container
		attribute :id, String, :default => :generate_id
		attribute :url, String
		attribute :name, String
		attribute :description, ContainerDescription

		def generate_id
			Digest::SHA256.hexdigest(url)
		end

		def get_description
			@description = ContainerDescription.fetch(self)
		end

		def save
			ServiceRepository.save(self.attributes)
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

	class ContainerDescription < Entity
		attribute :name, String
		attribute :description, String

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
	end
end
