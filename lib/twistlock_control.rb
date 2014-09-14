require 'entity'

require 'entities/application'

module TwistlockControl
    class << self
        def configure
            yield self
        end
    end
end
