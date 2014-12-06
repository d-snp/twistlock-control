module TwistlockControl
	# A Service class describes a provisionable network service.
	class Service < Entity
		# The network services provided by this service. Each service is
		# identified with a name, for example: offers HTTP on port 80.
		attribute :provided_services, Hash[String => String]]

		# The service can depend on any other services. For example it might
		# require a MySQL service to be linked in on port 3047.
		attribute :consumed_services, Hash[String => String]
	end
end
