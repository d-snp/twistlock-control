module TwistlockControl
	# A service link can for example be, the 'MySQL' container exposes a 'mysql' port.
	# The 'RubyForum' container consumes this service by listening on the 'mysql' port.
	# The accompanying ServiceLink would be:
	# {
	# provider_name: "MySQL",
	# provider_port_name: "mysql",
	# consumer_name: "RubyForum",
	# consumer_port: "mysql"
	# }
	class ServiceLink < Entity
		attribute :provider_name, String
		attribute :consumer_name, String
		attribute :provider_port_name, String
		attribute :consumer_port_name, String
	end

	# A CompositeService is a service that consists of a number of services working together to
	# provide a single service. For example a web forum service might consist of a MySQL service,
	# for persistant storage, and a Ruby HTTP service that serves HTML sites and queries the storage.
	# In the CompositeService you may choose to only expose the HTTP service, making it only possible
	# to query the MySQL database through the Ruby application, which might be considered proper
	# encapsulation.
	#
	# Relations between services are described by the links attribute. A link is characterized by
	# a producer and a consumer, the consumer will connect to the producers provided service.
	class CompositeService < Service
		attribute :service_type, Symbol, default: :composite
		attribute :id, String, default: :generate_id
		attribute :name, String

		# Link cases:
		#
		#   1. Multi-consumer: a webservice might have 10 Ruby frontend apps, all connecting
		#      to the same database. Simply increasing the amount of service instances with
		#      the same links will solve this case. Question: do we want to specify this
		#      possibility in each service link, or can we simply assume all services are
		#      scalable in this way? Not all are, but maybe that's a service property, not
		#      a relation property.
		#   2. Multi-producer: A MongoDB cluster might have multiple master nodes. A Ruby
		#      frontend app may want to connect to any of these. The problem is that it will
		#      have to know before starting on which ports this potentially infinite number
		#      of servers has, and somehow choose between them. A solution might be to couple
		#      each Ruby app with a random master.
		attribute :service_relations, Hash[String => String]
		attribute :links, [ServiceLink]

		# A provided service basically means this composite service exposes a port of one
		# of its services. In the forum example, it could be the port 80 http service of
		# the RubyForum container.
		#
		# {
		# 	http: { RubyForum: 'http' }
		# }
		#
		attribute :provided_services, Hash[String => String]

		def services
			Service.find_with_ids(service_relations.values)
		end

		def add_service(service, name = nil)
			service_relations[name || service.name] = service.id
			save
		end

		def containers
			result = []
			services = self.services.map(&:service)
			composites = services.select { |s| s.service_type == :composite }
			containers = services.select { |s| s.service_type == :container }
			result += containers
			composites.each do |c|
				result += c.containers
			end
			result
		end

		def serialize
			super.merge! links: links.map(&:attributes)
		end

		private

		def generate_id
			name.downcase.gsub(' ', '-')
		end
	end
end
