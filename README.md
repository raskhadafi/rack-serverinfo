# Rack::Serverinfo

This rack middleware shows the hostname of the app server, under which user the app is running and what kind of rails env the app has.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-serverinfo'
```

In the application.rb add this:

```ruby
config.middleware.use Rack::Serverinfo
```

Maybe you do not want it in production so add this:

```ruby
config.middleware.use Rack::Serverinfo unless Rails.env.production?
```

## Contributing

1. Fork it ( https://github.com/raskhadafi/rack-serverinfo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Kudo

* Swiss Life Select AG
