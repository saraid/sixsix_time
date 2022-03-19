require "sixsix_time/version"
require "sixsix_time/duration"
require "sixsix_time/calculator"

class SixSixTime
  def self.at(time)
    new(time, Calculator.new(time).current)
  end

  def self.now
    at(Time.now)
  end

  def self.configure_location(country:, latitude:, longitude:)
    TwilightCalculator.here = TwilightCalculator::GeocodeResult.new(country, latitude, longitude)
  end

  class NotConfigured < StandardError
    #TODO Make better
    def message
      'timezone not found; use SixSixTime.configure_location to set'
    end
  end

  def initialize(date, sixsix_hours)
    @year = date.year
    @month = date.month
    @day = date.day
    @zone = date.zone

    @hour =
      if sixsix_hours.floor > 12 then sixsix_hours - 12
      elsif sixsix_hours.floor.zero? then 12
      else sixsix_hours
      end.floor
    @hour = 12 + @hour if @hour < 0
    @fractional_hour = Rational(((sixsix_hours - sixsix_hours.floor) * 60).floor, 60)
    @period =
      case sixsix_hours
      when 0..12 then 'AM'
      else 'PM'
      end
  end

  def to_s
    date = [@year, '%02d' % @month, '%02d' % @day].join('-')
    fraction = @fractional_hour.numerator * 60 / @fractional_hour.denominator
    time = ['%02d' % @hour, "#{'%02d' % fraction}/60", @period].join(' ')

    [date, time, @zone].join(' ')
  end
end
