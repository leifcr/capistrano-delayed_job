# Delayed Job - Monit
# Setup and management of Monit for Delayed Job
#
require 'capistrano-base_helper/base_helper'
require 'capistrano-base_helper/monit_base'

Capistrano::Configuration.instance(true).load do
  after "monit:setup", "delayed_job:monit:setup"
  after "delayed_job:monit:setup", "delayed_job:monit:enable"
  after "delayed_job:monit:enable", "monit:reload"

  before "delayed_job:monit.disable", "delayed_job:monit:unmonitor"
  after  "delayed_job:monit:disable", "monit:reload"

  # start service after update in case it has not been stopped
  # after "deploy:update", "delayed_job:monit:start"
  # Not needed?

  namespace :delayed_job do
    namespace :monit do
      desc "Setup Delayed Job monit-service"
      task :setup, :roles => [:app, :web, :db] do
        # Upload configuration
        Capistrano::BaseHelper::generate_and_upload_config(delayed_job_local_monit_config, File.join(fetch(:monit_available_path), "#{fetch(:delayed_job_runit_service_name)}.conf"))
        # Enable monitor
      end
    
      desc "Enable monit services for Delayed Job"
      task :enable, :roles => [:app, :web, :db] do
        Capistrano::MonitBase::Service.enable("#{fetch(:delayed_job_runit_service_name)}.conf")
      end

      desc "Disable and stop monit services for Delayed Job"
      task :disable, :roles => [:app, :web, :db] do
        Capistrano::MonitBase::Service.disable("#{fetch(:delayed_job_runit_service_name)}.conf")
      end

      desc "Start monit services for Delayed Job (will also try to start the service)"
      task :start, :roles => [:app, :web, :db] do
        Capistrano::MonitBase::Service.command_monit("start", fetch(:delayed_job_monit_service_name))
      end

      desc "Stop monit services for Delayed Job (will also stop the service)"
      task :stop, :roles => [:app, :web, :db] do
        Capistrano::MonitBase::Service.command_monit("stop", fetch(:delayed_job_monit_service_name))
      end

      desc "Restart monit services for Delayed Job"
      task :restart, :roles => [:app, :web, :db] do
        Capistrano::MonitBase::Service.command_monit("restart", fetch(:delayed_job_monit_service_name))
      end

      desc "Monitor Delayed Job"
      task :monitor, :roles => [:app, :web, :db] do
        Capistrano::MonitBase::Service.command_monit("monitor", fetch(:delayed_job_monit_service_name))
      end

      desc "Unmonitor Delayed Job"
      task :unmonitor, :roles => [:app, :web, :db] do
        Capistrano::MonitBase::Service.command_monit("unmonitor", fetch(:delayed_job_monit_service_name))
      end

      desc "Purge Delayed Job monit configuration"
      task :unmonitor, :roles => [:app, :web, :db], :on_error => :continue do
      end      

    end

  end
end