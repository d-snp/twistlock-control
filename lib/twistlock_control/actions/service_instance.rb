module TwistlockControl
	# Actions that Rotterdam needs that this library implements:
	module Actions
		#  * Creating service instances
		#  * Configuring service instances
		module ServiceInstance
			class << self
				def add(name, service)
					configuration = build_configuration(service)
					instance = Entities::ServiceInstance.new(service_id: service.id, name: name, configuration: configuration)
					instance.save
					instance
				end

				def update
					fail 'not implemented'
				end

				def remove
					fail 'not implemented'
				end

				private

				def build_configuration(service)
					case service.service_type
					when :container then Entities::ContainerConfiguration.new(service_id: service.id)
					when :composite
						Entities::CompositeConfiguration.new(
							service_id: service.id,
							configurations: service.services.map { |s| build_configuration(s) }
						)
					else
						fail "Unknown service type: #{service.service_type}"
					end
				end
			end
		end
	end
end
