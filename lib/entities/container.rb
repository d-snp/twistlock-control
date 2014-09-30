require 'digest'
require 'securerandom'
require 'fileutils'
require 'yaml'

module TwistlockControl
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

	class Container < Entity
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
			ContainerRepository.save(self.attributes)
		end

		def remove
			ContainerRepository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = ContainerRepository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.find_with_ids(ids)
			ContainerRepository.find_with_ids(ids).map {|a| new(a) }
		end

		def self.all()
			ContainerRepository.all.map {|a| new(a) }
		end
	end
end
