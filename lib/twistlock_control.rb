require 'connection_pool'
require 'rethinkdb'

require 'twistlock_control/provisioner_api'
require 'twistlock_control/rethinkdb_repository'

require 'twistlock_control/entities'
require 'twistlock_control/actions'
require 'twistlock_control/collections'

#
# TwistLockControl main module.
#
# Configure TwistlockControl by calling `TwistlockControl.configure`
# and passing it a block in which you set the attributes.
#
module TwistlockControl
	class << self
		Configuration = Struct.new(
			:connection_pool_size,
			:connection_pool_timeout,
			:rethinkdb_host,
			:rethinkdb_port,
			:database_name
		) do
			def initialize(*args)
				return super unless args.length == 1 and args.first.instance_of? Hash
				args.first.each_pair do |k, v|
					self[k] = v if respond_to? k
				end
			end
		end

		CONFIGURATION_DEFAULTS = {
			connection_pool_size: 5,
			connection_pool_timeout: 5,
			rethinkdb_host: 'localhost',
			rethinkdb_port: 28_015,
			database_name: 'twistlock-control'
		}

		attr_reader :configuration

		def configure(options = {})
			@configuration = Configuration.new(CONFIGURATION_DEFAULTS.merge(options))

			yield configuration if block_given?

			setup_connection_pool
		end

		def database
			RethinkDB::RQL.new.db(configuration.database_name)
		end

		def with_connection
			@connection_pool.with do |conn|
				yield conn
			end
		end

		private

		def setup_connection_pool
			@connection_pool = ConnectionPool.new(
				size:    configuration.connection_pool_size,
				timeout: configuration.connection_pool_timeout
			) do
				RethinkDB::Connection.new(
					host: configuration.rethinkdb_host,
					port: configuration.rethinkdb_port
				)
			end
		end
	end
end
