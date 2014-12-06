module TwistlockControl
	# Both Container and Service inherit from Service base. It should actually just be called service,
	# a container would be a concrete service, and the current service should be virtual service. 
	class Service < Entity
		attribute :provided_services, Hash[String => Hash[String => String]]
		attribute :links, Array[[Hash[String => String],Hash[String => String]]]
	end
end
