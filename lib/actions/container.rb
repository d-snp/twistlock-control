module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Importing container descriptions
		module Container
			def self.add
			end

			def self.update
			end

			def self.remove
			end

			def self.synchronize_description(container)
				container.description = fetch_container_description(container)
				container.save
			end

			def self.fetch_container_description(container)
				nonce = SecureRandom.hex[0..7]
				dirname = "/tmp/#{container.name}-#{nonce}"
				FileUtils.mkdir_p dirname
				Dir.chdir(dirname) do
					`git clone -n --depth=1 #{container.url} .`
					`git checkout HEAD twistlock.yml`
					result = `cat twistlock.yml && rm -rf #{dirname}`
					ContainerDescription.new(YAML.load(result))
				end
			end
		end
	end
end
