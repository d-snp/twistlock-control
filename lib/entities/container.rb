module TwistlockControl
	class Container < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String
		attribute :url, String

		def generate_id
			name.downcase.gsub(' ','-')
		end

		def save
			ContainerRepository.save(self.attributes)
		end

		def remove
			ContainerRepository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = ContainerRepository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.find_with_ids(ids)
			ContainerRepository.find_with_ids(ids).map {|a| new(a) }
		end

		def self.all()
			ContainerRepository.all.map {|a| new(a) }
		end
	end
end
