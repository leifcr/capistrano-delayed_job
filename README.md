# Capistrano Recipes for Delayed Job

This gem provides recipes for [Delayed Job](https://github.com/collectiveidea/delayed_job) to setup runit and monit

## Usage

Add it to your Gemfile without requiring it

```ruby
gem 'capistrano-delayed_job', :require => false
```

In your deploy.rb:

```ruby
require 'capistrano/delayed_job'
```

### Monit

```ruby
cap delayed_job:monit:disable          # Disable and stop monit services for Delayed Job
cap delayed_job:monit:enable           # Enable monit services for Delayed Job
cap delayed_job:monit:monitor          # Monitor Delayed Job
cap delayed_job:monit:restart          # Restart monit services for Delayed Job
cap delayed_job:monit:setup            # Setup Delayed Job monit-service
cap delayed_job:monit:start            # Start monit services for Delayed Job (will also tr...
cap delayed_job:monit:stop             # Stop monit services for Delayed Job (will also sto...
cap delayed_job:monit:unmonitor        # Purge Delayed Job monit configuration
```

### Runit

```ruby
cap delayed_job:runit:disable          # Disable Delayed Job runit-service
cap delayed_job:runit:enable           # Enable Delayed Job runit-service
cap delayed_job:runit:flush_sockets    # Flush delayed_job sockets, as they can end up 'han...
cap delayed_job:runit:once             # Start Delayed Job runit-service only ONCE (no supe...
cap delayed_job:runit:purge            # Purge Delayed Job runit configuration
cap delayed_job:runit:quit             # Quit the Delayed Job runit-service
cap delayed_job:runit:restart          # Restart Delayed Job runit-service
cap delayed_job:runit:setup            # Setup Delayed Job runit-service
cap delayed_job:runit:start            # Start Delayed Job runit-service
cap delayed_job:runit:stop             # Stop Delayed Job runit-service
```

## Configuration

See delayed_job/config.rb for default options, and ovveride any in your deploy.rb file.

## Contributing

* Fork the project
* Make a feature addition or bug fix
* Please test the feature or bug fix
* Make a pull request

## Copyright

(c) 2013 Leif Ringstad. See LICENSE for details
