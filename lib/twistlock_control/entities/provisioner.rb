require 'digest'

module TwistlockControl
	module Entities
		# A provisioner is a machine capable of provisioning containers
		class Provisioner < PersistedEntity
			repository RethinkDBRepository['provisioners']

			attribute :id, String, default: :generate_id
			attribute :name, String
			attribute :url, String

			def self.api
				@api ||= ProvisionerAPI.new(url)
			end

			private

			def generate_id
				Digest::SHA256.hexdigest(url)
			end
		end
	end
end
