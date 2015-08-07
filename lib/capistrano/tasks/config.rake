require 'capistrano/helpers/base'
require 'capistrano/helpers/delayed_job/template_paths'
include Capistrano::Helpers::Base

namespace :load do
  task :defaults do
    set :delayed_job_runit_base_service_name, 'delayed_job'

    # The number of workers to run
    # Will create X number of runit services/monit monitors.
    # Remember to purge/remove config before changing this value down
    # Default to 2 workers
    set :delayed_job_workers, 2

    # The binary to trigger delayed job
    set :delayed_job_bin, 'bundle exec rake jobs:work'

    # runit defaults
    set :delayed_job_restart_interval, proc { fetch(:runit_restart_interval) }
    set :delayed_job_restart_count, proc { fetch(:runit_restart_count) }
    set :delayed_job_autorestart_clear_interval, proc { fetch(:runit_autorestart_clear_interval) }

    # runit templates
    set :delayed_job_runit_run_template, File.join(Capistrano::Helpers::DelayedJob::TemplatePaths.template_base_path, 'runit', 'run.erb') # rubocop:disable Metrics/LineLength
    set :delayed_job_runit_finish_template, File.join(Capistrano::Helpers::DelayedJob::TemplatePaths.template_base_path, 'runit', 'finish.erb') # rubocop:disable Metrics/LineLength
    set :delayed_job_runit_log_run_template, File.join(Capistrano::Helpers::DelayedJob::TemplatePaths.template_base_path, 'runit', 'log', 'run.erb') # rubocop:disable Metrics/LineLength

    # monit configuration
    set :delayed_job_monit_base_service_name,  proc { fetch(:delayed_job_runit_base_service_name) }
    # Each worker would be likely to use at least 60-70mb ram for an app with many gems
    set :delayed_job_monit_memory_alert_threshold,    '100.0 MB for 2 cycles'
    # Give the delayed_job_workers some headroom
    set :delayed_job_monit_memory_restart_threshold,  '150.0 MB for 3 cycles'
    set :delayed_job_monit_cpu_alert_threshold,       '90% for 2 cycles'
    set :delayed_job_monit_cpu_restart_threshold,     '95% for 5 cycles'

    set :delayed_job_monit_config_template, File.join(Capistrano::Helpers::DelayedJob::TemplatePaths.template_base_path, 'monit', 'delayed_job.conf.erb') # rubocop:disable Metrics/LineLength

    set :monit_application_delayed_job_group_name,  proc { "#{user_app_env_underscore}_delayed_job" }
  end
end
