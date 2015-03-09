module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Adding provisioners
		module Provisioner
			class << self
				def add(properties)
					provisioner = TwistlockControl::Provisioner.new(properties)
					provisioner.save
					provisioner
				end

				def update(id, properties)
					provisioner = TwistlockControl::Provisioner.find_by_id(id)
					provisioner.attributes = provisioner.attributes.merge properties
					provisioner.save
				end

				def remove(id)
					TwistlockControl::Provisioner.delete(id)
				end
			end
		end
	end
end
