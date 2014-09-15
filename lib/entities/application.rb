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

		def self.find_by_id(id)
			new(ApplicationRepository.find_by_id(id))
		end
	end
end
