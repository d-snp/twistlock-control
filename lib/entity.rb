require 'virtus'

module TwistlockControl
	class Entity
		include Virtus.model

		def ==(other)
			return false if !other.respond_to? :attributes
			attributes == other.attributes
		end

		def serialize
			attributes.dup
		end
	end

	class PersistedEntity < Entity
		def self.find_by_id(id)
			deserialize repository.find_by_id(id)
		end

		def self.deserialize(attrs)
			return nil if attrs.nil?
			new(attrs)
		end

		def self.find_with_ids(ids)
			repository.find_with_ids(ids).map{|a| deserialize a }
		end

		def self.all
			repository.all.map{ |a| deserialize a }
		end

		def self.repository(repository=nil)
			if repository
				@repository = repository
			else
				@repository || superclass.repository
			end
		end

		def save
			repository.save(serialize)
		end

		def remove
			repository.remove(id)
		end

		def repository
			self.class.repository
		end
	end
end
