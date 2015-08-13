require 'capistrano/dsl/base_paths'
require 'capistrano/dsl/runit_paths'
require 'capistrano/helpers/base'
require 'capistrano/helpers/monit'
require 'capistrano/helpers/delayed_job/monit'
include Capistrano::DSL::BasePaths
include Capistrano::DSL::RunitPaths
include Capistrano::Helpers::Base
include Capistrano::Helpers::Monit
include Capistrano::Helpers::DelayedJob::Monit

namespace :delayed_job do
  namespace :monit do
    desc 'MONIT: Setup Delayed Job service'
    task :setup do
      on roles(:app) do |host|
        (1..fetch(:delayed_job_workers)).each do |n|
          info "MONIT: Uploading configuration for Delayed Job worker #{n} for #{fetch(:application)} on #{host}"
          # Upload configuration
          set :tmp_delayed_job_monit_service_name, delayed_job_monit_app_env_service_name(n)
          set :tmp_worker_number, n
          set :tmp_delayed_job_pid_file, delayed_job_pid_file(n)
          upload! template_to_s_io(fetch(:delayed_job_monit_config_template)), available_configuration_with_path(n)
        end
      end
    end

    desc 'MONIT: Enable services for Delayed Job'
    task :enable do
      on roles(:app) do |host|
        (1..fetch(:delayed_job_workers)).each do |n|
          info "MONIT: Enabling service for Delayed Job worker #{n} for #{fetch(:application)} on #{host}"
          enable_monitor(available_configuration_file(n))
        end
      end
    end

    desc 'MONIT: Disable and Stop services for Delayed Job'
    task :disable do
      on roles(:app) do |host|
        (1..fetch(:delayed_job_workers)).each do |n|
          info "MONIT: Disabling service for Delayed Job worker #{n} for #{fetch(:application)} on #{host}"
          disable_monitor(available_configuration_file(n))
        end
      end
    end

    %w(start stop restart monitor unmonitor).each do |cmd|
      desc "MONIT: #{cmd.capitalize} Delayed Job"
      task cmd.to_sym do
        on roles(:app) do |host|
          (1..fetch(:delayed_job_workers)).each do |n|
            info "MONIT: #{cmd} Delayed Job worker #{n} for #{fetch(:application)} on #{host}"
            command_monit(cmd, available_configuration_file(n))
          end
        end
      end
    end

    desc 'MONIT: Purge Delayed Job configuration'
    task :purge do
      on roles(:app) do |host|
        (1..fetch(:delayed_job_workers)).each do |n|
          info "MONIT: Purging config for Delayed Job worker #{n} for #{fetch(:application)} on #{host}"
        end
      end
    end
  end
end

after 'monit:setup', 'delayed_job:monit:setup'
# after 'delayed_job:monit:setup', 'delayed_job:monit:enable'
after 'delayed_job:monit:enable', 'monit:reload'

before 'delayed_job:monit:disable', 'delayed_job:monit:unmonitor'
after 'delayed_job:monit:disable', 'monit:reload'

# start service after update in case it has not been stopped
# This shouldn't be necessary, as monit should pick up a non-running service.
# Starting it here might trigger double starting if monit is triggered simultaniously.
# after "deploy:update", "delayed_job:monit:start"
