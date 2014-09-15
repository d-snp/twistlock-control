module TwistlockControl
	class Application < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String

		def generate_id
			name.downcase.gsub(' ','-')
		end

		def save
			ApplicationRepository.save(self)
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
