module TwistlockControl
	# A Service class describes a provisionable network service.
	class Service < Entity
		# The network services provided by this service. Each service is
		# identified with a name, for example: offers HTTP on port 80.
		attribute :provided_services, Hash[String => Integer]

		# The service can depend on any other services. For example it might
		# require a MySQL service to be linked in on port 3047.
		attribute :consumed_services, Hash[String => Integer]

		def self.find_by_id(id)
			attrs = ServiceRepository.find_by_id(id)
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
