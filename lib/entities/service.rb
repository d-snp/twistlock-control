module TwistlockControl
	class ServiceRelation < Entity
		attribute :name, String
		attribute :container_id, String
		attribute :service_id, String

		def container
			Container.find_by_id(container_id)
		end

		def service
			Service.find_by_id(service_id)
		end
	end

	class Service < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String
		attribute :services, [ServiceRelation]
		attribute :provided_services, Hash[String => Hash[String => String]]
		attribute :links, Array[[Hash[String => String],Hash[String => String]]]

		def generate_id
			name.downcase.gsub(' ','-')
		end

		def add_service(service, name=nil)
			rel = ServiceRelation.new(
				name: name ? name : service.name,
				service_id: service.id
			)
			services.push rel
			save
		end

		def add_container(container, name=nil)
			rel = ServiceRelation.new(
				name: name ? name : container.name,
				container_id: container.id
			)
			services.push rel
			save
		end

		def expose(provided_service_name, service)
			provided_services[provided_service_name] = service
			save
		end

		def link(provided_service, consumed_service)
			links.push [provided_service, consumed_service]
			save
		end

		def save
			attrs = self.attributes
			service_attrs = services.map {|s|s.attributes}
			attrs[:services] = service_attrs
			ServiceRepository.save(attrs)
		end

		def remove
			ServiceRepository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = ServiceRepository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.find_with_ids(service_ids)
			ServiceRepository.find_with_ids(service_ids).map {|a| new(a) }
		end

		def self.all()
			ServiceRepository.all.map {|a| new(a) }
		end
	end
end
