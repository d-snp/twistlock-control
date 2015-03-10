module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Importing container descriptions
		module Container
			class << self
				def add(properties)
					container = Entities::Container.new(properties)
					synchronize_description(container)
					container
				end

				def update
					fail 'not implemented'
				end

				def remove
					fail 'not implemented'
				end

				def synchronize_description(container)
					container.description = fetch_container_description(container)
					container.save
				end

				private

				def fetch_container_description(container)
					nonce = SecureRandom.hex[0..7]
					dirname = "/tmp/#{container.name}-#{nonce}"
					FileUtils.mkdir_p dirname
					Dir.chdir(dirname) do
						`git clone -n --depth=1 #{container.url} .`
						`git checkout HEAD twistlock.yml`
						result = `cat twistlock.yml && rm -rf #{dirname}`
						Entities::ContainerDescription.new(YAML.load(result))
					end
				end
			end
		end
	end
end
