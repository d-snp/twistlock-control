module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Adding provisioners
		module Provisioner
			class << self
				def add(properties)
					provisioner = Provisioner.new(properties)
					provisioner.save
				end

				def update(id, properties)
					provisioner = Provisioner.find_by_id(id)
					properties.each do |k, v|
						properties.attributes[k] = v
					end
					provisioner.save
				end

				def remove(id)
					Provisioner.delete(id)
				end
			end
		end
	end
end
