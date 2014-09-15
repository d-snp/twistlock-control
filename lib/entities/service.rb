module TwistlockControl
	class Service < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String
		attribute :service_ids, Array[String]

		def generate_id
			name.downcase.gsub(' ','-')
		end

		def add_service(service)
			service_ids << service.id
			save
		end

		def services
			Service.find_with_ids(service_ids)
		end

		def save
			ServiceRepository.save(self.attributes)
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
