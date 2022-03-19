require 'solareventcalculator'

class SixSixTime
  class TwilightCalculator
    using Refinements::Duration

    HORIZON_THRESHOLD = {
      official: 90.8333,
      civil: 96,
      nautical: 102,
      astronomical: 108
    }

    class GeocodeResult < Struct.new(:country, :latitude, :longitude); end
    @@here = GeocodeResult.new('United States', 47, -122) # a working default so that you can procrastinate footgunning.

    def self.here=(geocode_result)
      @@here = geocode_result
    end

    def self.here(whence: Time.now, where: @@here)
      (@here ||= {})[whence] ||= new(whence, where)
    end

    def initialize(current, geocode_result)
      @date = current
      @country = geocode_result.country
      @latitude = geocode_result.latitude
      @longitude = geocode_result.longitude
    end
    attr_reader :date, :country, :latitude, :longitude

    def sunrise_calculator
      @sunrise_calculator ||= SolarEventCalculator.new(date, latitude, longitude)
    end

    def sunset_calculator
      @sunset_calculator ||= SolarEventCalculator.new(date + 1.day, latitude, longitude)
    end

    def timezone
      @timezone ||= TZInfo::Country.all
        .find { _1.name == country || _1.code == country }
        .zone_info
        .select { TZInfo::Timezone.get(_1.identifier).abbr == date.zone }
        .sort_by { ((_1.latitude - latitude) ** 2 + (_1.longitude - longitude) ** 2) ** 0.5 }
        .first
        .tap { raise SixSixTime::NotConfigured if _1.nil? } # will happen if Time.now.zone isn't in the US and unconfigured.
        .timezone
    end

    def sunrise(which = :official)
      timezone.utc_to_local sunrises[which]
    end

    def sunset(which = :official)
      timezone.utc_to_local sunsets[which]
    end

    def sunrises
      @sunrises ||= HORIZON_THRESHOLD.transform_values do |degree|
        sunrise_calculator.compute_utc_solar_event(degree, true)
      end
    end

    def sunsets
      @sunsets ||= HORIZON_THRESHOLD.transform_values do |degree|
        sunset_calculator.compute_utc_solar_event(degree, false)
      end
    end
  end
end
