module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Adding provisioners
		module Provisioner
			class << self
				def add(properties)
					provisioner = Entities::Provisioner.new(properties)
					provisioner.save
					provisioner
				end

				def update(id, properties)
					provisioner = Entities::Provisioner.find_by_id(id)
					provisioner.attributes = provisioner.attributes.merge properties
					provisioner.save
				end

				def remove(id)
					Entities::Provisioner.delete(id)
				end
			end
		end
	end
end
