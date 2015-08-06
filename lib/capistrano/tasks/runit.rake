require 'capistrano/dsl/base_paths'
require 'capistrano/dsl/runit_paths'
require 'capistrano/helpers/base'
require 'capistrano/helpers/runit'
require 'capistrano/helpers/delayed_job/runit'

# require 'capistrano/runit'
namespace :delayed_job do
  include Capistrano::DSL::BasePaths
  include Capistrano::DSL::RunitPaths
  include Capistrano::Helpers::Base
  include Capistrano::Helpers::Runit

  desc 'Setup Delayed Job configuration'
  task :setup do
    on roles(:app) do
      execute :mkdir, "-p #{fetch(:sockets_path)}" if test("[ ! -d '#{fetch(:sockets_path)}' ]")
      upload! template_to_s_io(fetch(:puma_config_template)), fetch(:puma_config_file)
    end
  end

  namespace :runit do
    desc 'Setup Delayed Job runit-service'
    task :setup do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          # Create runit config
          if test("[ ! -d '#{runit_service_path(Capistrano::Helpers::DelayedJob::Runit.service_name(n))}' ]")
            execute :mkdir, "-p '#{runit_service_path(Capistrano::Helpers::DelayedJob::Runit.service_name(n))}'"
          end

          set :tmp_delayed_job_runit_service_name, Capistrano::Helpers::DelayedJob::Runit.service_name(n)
          set :tmp_worker_number, n

          upload! template_to_s_io(fetch(:delayed_job_runit_run_template)), runit_service_run_config_file(Capistrano::Helpers::DelayedJob::Runit.service_name(n)) # rubocop:disable Metrics/LineLength
          upload! template_to_s_io(fetch(:delayed_job_runit_finish_template)), runit_service_finish_config_file(Capistrano::Helpers::DelayedJob::Runit.service_name(n)) # rubocop:disable Metrics/LineLength

          # Log scripts for runit service
          if test("[ ! -d '#{runit_service_log_path(Capistrano::Helpers::DelayedJob::Runit.service_name(n))}' ]")
            execute :mkdir, "-p '#{runit_service_log_path(Capistrano::Helpers::DelayedJob::Runit.service_name(n))}'"
          end

          set :tmp_delayed_job_log_path, Capistrano::Helpers::DelayedJob::Runit.log_path(n)

          upload! template_to_s_io(fetch(:delayed_job_runit_log_run_template)), runit_service_log_run_file(Capistrano::Helpers::DelayedJob::Runit.service_name(n)) # rubocop:disable Metrics/LineLength

          # Make scripts executable
          runit_set_executable_files(Capistrano::Helpers::DelayedJob::Runit.service_name(n))

          # Create log paths for the service
          if test("[ ! -d '#{runit_var_log_service_single_service_path(Capistrano::Helpers::DelayedJob::Runit.service_name(n))}' ]")
            execute :mkdir, "-p '#{runit_var_log_service_single_service_path(Capistrano::Helpers::DelayedJob::Runit.service_name(n))}'"
          end
        end
      end
    end

    desc 'Enable Delayed Job runit-services'
    task :enable do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          enable_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n))
        end
      end
    end

    desc 'Disable Delayed Job runit-services'
    task :disable do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          disable_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n))
        end
      end
    end

    desc 'Start Delayed Job runit-services'
    task :start do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          control_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n), 'start')
        end
      end
    end

    desc 'Start Delayed Job runit-services only ONCE (no supervision...)'
    task :once do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          control_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n), 'once')
        end
      end
    end

    desc 'Stop Delayed Job runit-services'
    # :on_error => :continue  should be added when cap3 equivalent has been figured out
    task :stop do
      on roles(:app) do
        # will wait 45 seconds for delayed job to shut down/finish current jobs, to allow it to
        # Process ongoing tasks.
        (1..fetch(:delayed_job_workers)).each do |n|
          begin
            control_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n), 'force-stop', '-w 45')
          rescue
          end
        end
      end
    end

    desc 'Quit the Delayed Job runit-services'
    # :on_error => :continue  should be added when cap3 equivalent has been figured out
    task :quit do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          control_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n), 'quit')
        end
      end
    end

    desc 'Restart Delayed Job runit-services'
    task :restart do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          control_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n), 'restart')
        end
      end
    end

    desc 'Purge Delayed Job runit configuration'
    # :on_error => :continue  should be added when cap3 equivalent has been figured out
    task :purge do
      on roles(:app) do
        (1..fetch(:delayed_job_workers)).each do |n|
          disable_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n))
          purge_service(Capistrano::Helpers::DelayedJob::Runit.service_name(n))
        end
      end
    end
  end
end

after 'runit:setup', 'delayed_job:runit:setup'

# enable service after update in case it has been disabled
# Service should probably be started as well?
after 'deploy:updated', 'delayed_job:runit:enable'
# before 'delayed_job:runit:setup', 'delayed_job:flush_sockets'
before 'delayed_job:runit:setup', 'delayed_job:setup'
before 'delayed_job:runit:quit', 'delayed_job:runit:stop'
