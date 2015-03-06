module TwistlockControl
	# A container instance represents a container currently
	# running on a provisioner.
	class ContainerInstance < PersistedEntity
		repository RethinkDBRepository['container_instances']

		attribute :id, String, default: :generate_id

		# Attributes as dictated by provisioner
		attribute :container_id
		attribute :ip_address
		attribute :provisioner_id

		private

		def generate_id
			Digest::SHA256.hexdigest("#{container_id}-#{provisioner_id}")
		end
	end
end
