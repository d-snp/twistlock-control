module TwistlockControl
	class ServiceBase < Entity
		attribute :provided_services, Hash[String => Hash[String => String]]
		attribute :links, Array[[Hash[String => String],Hash[String => String]]]
	end
end
