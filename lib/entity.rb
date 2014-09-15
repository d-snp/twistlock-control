require 'virtus'

module TwistlockControl
	class Entity
		include Virtus.model

		def ==(other)
			return false if !other.respond_to? :attributes
			attributes == other.attributes
		end
	end
end
