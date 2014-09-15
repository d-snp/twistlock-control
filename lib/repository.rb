module TwistlockControl
	class Repository
		def self.find
		end

		class << self
			def table_name(name=nil)
				if name
					@table_name = name
				else
					@table_name
				end
			end
		end
	end
end
