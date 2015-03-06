module TwistlockControl
	# A Service class describes a provisionable network service.
	class Service < PersistedEntity
		repository RethinkDBRepository['services']

		def self.deserialize(attrs)
			return nil if attrs.nil?

			case attrs['service_type']
			when 'container' then Container.new(attrs)
			when 'composite' then CompositeService.new(attrs)
			else
				fail "Unknown service_type: #{attrs[:service_type]}"
			end
		end
	end
end
