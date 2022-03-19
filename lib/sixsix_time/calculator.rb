require_relative './twilight_calculator'

class SixSixTime
  class Calculator
    def initialize(current = Time.now)
      @now = current
      @current = sixsix_landmark + stretched_offset
    end
    attr_reader :now, :current

    def yesterday
      @yesterday ||= TwilightCalculator.here(whence: now - 1.day)
    end

    def today
      @today ||= TwilightCalculator.here(whence: now)
    end

    def tomorrow
      @tomorrow ||= TwilightCalculator.here(whence: now + 1.day)
    end

    def timezone
      today.timezone
    end

    def before_dawn?
      today.sunrise > now
    end

    def daytime?
      today.sunset > now
    end

    def after_dusk?
      today.sunset < now
    end

    def sixsix_landmark
      if before_dawn? then -6
      elsif daytime? then 6
      elsif after_dusk? then 18
      else raise IndexError, 'where are we'
      end
    end

    def utc_landmark
      if before_dawn? then yesterday.sunset
      elsif daytime? then today.sunrise
      elsif after_dusk? then today.sunset
      else raise IndexError, 'where are we'
      end
    end

    def utc_offset_in_seconds
      now - utc_landmark
    end

    def current_twelve_hour_period_beginning
      utc_landmark
    end

    def current_twelve_hour_period_ending
      if before_dawn? then today.sunrise
      elsif daytime? then today.sunset
      elsif after_dusk? then tomorrow.sunrise
      else raise IndexError, 'where are we'
      end
    end

    def current_twelve_hour_period
      current_twelve_hour_period_ending - current_twelve_hour_period_beginning
    end

    def hour_length
      @hour_length ||= current_twelve_hour_period.fdiv(12)
    end

    def stretched_offset
      utc_offset_in_seconds.fdiv hour_length
    end
  end
end

