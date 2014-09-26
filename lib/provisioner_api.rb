require 'net/http'
require 'uri'

module TwistlockControl
	class ProvisionerAPI
		attr_reader :url

		def initialize(url)
			@url = url
		end

		def container_description(name)
			JSON.parse get("templates/#{name}")
		end

		def add_container(name, url)
			JSON.parse post('templates', name: name, url: url)
		end

		private
		def uri(path)
			URI(url + '/' + path)
		end

		def get(path)
			Net::HTTP.get uri(path)
		end

		def post(path, params)
			result = Net::HTTP.post_form uri(path), params
			result.body
		end
	end
end
