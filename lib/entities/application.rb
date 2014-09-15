module TwistlockControl
	class Application < Entity
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
			ApplicationRepository.save(self.attributes)
		end

		def remove
			ApplicationRepository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = ApplicationRepository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.all()
			ApplicationRepository.all.map {|a| new(a) }
		end
	end
end
