module TwistlockControl
	# A Service class describes a provisionable network service.
	class Service < PersistedEntity
		repository ServiceRepository
		
		def create_instance(name)
			ServiceInstance.create(name, self)
		end

		def self.deserialize(attrs)
			return nil if attrs.nil?

			case attrs['service_type']
			when 'container'
				Container.new(attrs)
			when 'composite'
				CompositeService.new(attrs)
			else
				puts attrs.inspect
				raise "Unknown service_type: #{attrs[:service_type]}" 
			end
		end
	end
end
