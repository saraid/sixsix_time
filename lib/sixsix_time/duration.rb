class SixSixTime
  module Refinements
    module Duration
      refine Numeric do
        def second
          self
        end
        alias seconds second

        def minute
          self * 60.seconds
        end
        alias minutes minute

        def hour
          self * 60.minutes
        end
        alias hours hour

        def day
          self * 24.hours
        end
        alias days day
      end
    end
  end
end
