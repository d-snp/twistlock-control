require 'net/http'
module TwistlockControl
	class ProvisionerAPI
		attr_reader :url

		def initialize(url)
			@url = url
		end

		def container_description(name)
			JSON.parse get("templates/#{name}")
		end

		private
		def get(path)
			Net::HTTP.get(url, '/' + path)
		end
	end
end
