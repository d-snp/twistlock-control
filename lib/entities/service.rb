module TwistlockControl
	# A Service class describes a provisionable network service.
	class Service < Entity
		def create_instance(name)
			ServiceInstance.create(name, self)
		end

		def self.find_by_id(id)
			deserialize ServiceRepository.find_by_id(id)
		end

		def self.find_with_ids(ids)
			ServiceRepository.find_with_ids(ids).map{|a| deserialize a }
		end

		def self.all
			ServiceRepository.all.map{ |a| deserialize a }
		end

		def self.deserialize(attrs)
			return nil if attrs.nil?

			case attrs['service_type']
			when 'container'
				Container.new(attrs)
			when 'composite'
				CompositeService.new(attrs)
			else
				puts attrs.inspect
				raise "Unknown service_type: #{attrs[:service_type]}" 
			end
		end
	end
end
