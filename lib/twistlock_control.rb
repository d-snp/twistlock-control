require 'connection_pool'
require 'rethinkdb'

require 'provisioner_api'

require 'rethinkdb_repository'

require 'entity'
require 'entities/provisioning_configuration'
require 'entities/service'
require 'entities/provisioner'
require 'entities/composite_service'
require 'entities/service_instance'
require 'entities/container'
require 'entities/container_instance'

require 'actions/container'
require 'actions/container_instance'
require 'actions/provisioner'
require 'actions/service'
require 'actions/service_instance'

#
# TwistLockControl main module.
#
# Configure TwistlockControl by calling `TwistlockControl.configure`
# and passing it a block in which you set the attributes.
#
module TwistlockControl
	class << self
		attr_accessor :connection_pool_size,
		              :connection_pool_timeout,
		              :rethinkdb_host,
		              :rethinkdb_port,
		              :database_name

		def configure
			yield self

			set_defaults

			setup_connection_pool
		end

		def database
			RethinkDB::RQL.new.db(database_name)
		end

		def with_connection
			@connection_pool.with do |conn|
				yield conn
			end
		end

		private

		def set_defaults
			@connection_pool_size ||= 5
			@connection_pool_timeout ||= 5
			@rethinkdb_host ||= 'localhost'
			@rethinkdb_port ||= 28_015
			@database_name ||= 'twistlock-control'
		end

		def setup_connection_pool
			@connection_pool = ConnectionPool.new(
				size:    connection_pool_size,
				timeout: connection_pool_timeout
			) do
				RethinkDB::Connection.new(
					host: rethinkdb_host,
					port: rethinkdb_port
				)
			end
		end
	end
end
