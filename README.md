# SixSixTime

Implementing 6/6 time as best as I can, because I can.

<img src="https://imgs.xkcd.com/comics/6_6_time_2x.png" />
[XKCD 2050](https://xkcd.com/2050/)

Implementation Decisions: Ignore minute and second resolution.
- Why? Because the purpose is to align the hour measurement with sunrise/sunset.
  Seconds are a metric system measurement and should not be stretched.
  Minutes likewise are meant for grouping seconds, mainly.
- You do want *fractional* hour resolution, though,
  so I've given some fake minutes as fractions rather than calling them minutes.

There is also [a Python implementation](https://github.com/Dmium/66Time).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sixsix_time'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sixsix_time

## Usage

```ruby
SixSixTime.configure_location(country: 'United States', latitude: 47, longitude: -122) # Seattle

SixSixTime.now.to_s #=> "2022-03-18 05 20/60 PM PDT"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sixsix_time.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
