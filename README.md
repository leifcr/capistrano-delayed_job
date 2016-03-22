# Capistrano Recipes for Delayed Job

This gem provides recipes for [Delayed Job](https://github.com/collectiveidea/delayed_job) to setup [runit](smarden.org/runit/) and [monit](http://mmonit.com/monit)

## Versioning

Use 3.x for capistrano 3

For capistrano2, see the capistrano2 branch (will not be updated)

## Usage

Add it to your Gemfile without requiring it

```ruby
gem 'capistrano-delayed_job', require: false
```

Now run ```bundle install```

Add this to your Capfile:

```ruby
require 'capistrano/delayed_job'
```
### Roles:

capistrano-delayed_job targets ```:worker``` roles by default.

### Monit

```
cap delayed_job:monit:disable          # Disable and stop monit services for Delayed Job
cap delayed_job:monit:enable           # Enable monit services for Delayed Job
cap delayed_job:monit:monitor          # Monitor Delayed Job
cap delayed_job:monit:restart          # Restart monit services for Delayed Job
cap delayed_job:monit:setup            # Setup Delayed Job monit-service
cap delayed_job:monit:start            # Start monit services for Delayed Job (will also tr...
cap delayed_job:monit:stop             # Stop monit services for Delayed Job (will also sto...
cap delayed_job:monit:unmonitor        # Purge Delayed Job monit configuration
```

#### Setup in your deploy file

You can add this to deploy.rb or env.rb in order to automatically start/stop puma using monit. It is not needed if you use runit to stop/start/restart the service.

```ruby
before "monit:unmonitor", "delayed_job:monit:stop"
after  "monit:monitor",   "delayed_job:monit:start"
```

### Runit

```
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

#### Setup in your deploy file

To use runit to start/stop/restart services instead of monit, use the example below.

```ruby
# stop before deployment
# (must be done after monit has stopped monitoring the task. If not, the service will be restarted by monit)
before "monit:unmonitor", "delayed_job:runit:stop"
# start before enabling monitor
before  "monit:monitor",   "delayed_job:runit:start"
# restart before enabling monitor / monitoring has been started
before  "monit:monitor",   "delayed_job:runit:restart"
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
