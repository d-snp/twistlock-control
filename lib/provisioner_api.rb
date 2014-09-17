module TwistlockControl
	class ProvisionerAPI
		attr_reader :url

		def initialize(url)
			@url = url
		end

		def container_description(container_url)
			raise "not implemented"
		end
	end
end
