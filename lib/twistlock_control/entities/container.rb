require 'digest'
require 'securerandom'
require 'fileutils'
require 'yaml'

module TwistlockControl
	module Entities
		# A RelatedServiceDescription is used to describe a provided
		# or consumed service.
		class RelatedServiceDescription < Entity
			attribute :port
			attribute :description
		end

		# A ContainerDescription represents the container description
		# file that's used to describe properties of containers.
		class ContainerDescription < Entity
			attribute :name, String
			attribute :description, String
			attribute :provided_services, Hash[String => RelatedServiceDescription]
			attribute :consumed_services, Hash[String => RelatedServiceDescription]

			def serialize
				provided_services = (provided_services || {}).inject({}) { |r, (k, v)| r[k] = v.attributes }
				consumed_services = (consumed_services || {}).inject({}) { |r, (k, v)| r[k] = v.attributes }
				attributes.dup.merge!(
					provided_services: provided_services,
					consumed_services: consumed_services
				)
			end
		end

		# A container is a service that can be provisioned on a Twistlock provisioner node.
		class Container < Service
			attribute :service_type, Symbol, default: :container
			attribute :id, String, default: :generate_id
			attribute :url, String
			attribute :name, String
			attribute :description, ContainerDescription

			# The network services provided by this service. Each service is
			# identified with a name, for example: offers HTTP on port 80.
			def provided_services
				description.provided_services
			end

			# The service can depend on any other services. For example it might
			# require a MySQL service to be linked in on port 3047.
			def consumed_services
				description.consumed_services
			end

			def serialize
				super.merge!(
					description: description ? description.serialize : nil
				)
			end

			private

			def generate_id
				Digest::SHA256.hexdigest(url)
			end
		end
	end
end
