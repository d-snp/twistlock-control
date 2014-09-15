module TwistlockControl
	class Provisioner < Entity
		attribute :id, String, :default => :generate_id
		attribute :name, String
		attribute :url, String

		def generate_id
			name.downcase.gsub(' ','-')
		end

		def save
			ProvisionerRepository.save(self.attributes)
		end

		def remove
			ProvisionerRepository.remove(id)
		end

		def self.find_by_id(id)
			if attributes = ProvisionerRepository.find_by_id(id)
				new(attributes)
			else
				nil
			end
		end

		def self.all()
			ProvisionerRepository.all.map {|a| new(a) }
		end
	end
end
