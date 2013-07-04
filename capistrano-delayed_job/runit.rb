# Delayed Job - Runit

require 'capistrano-base_helper/base_helper'
require 'capistrano-base_helper/runit_base'

Capistrano::Configuration.instance(true).load do
  after "deploy:setup", "delayed_job:runit:setup"

  # enable service after update in case it has not been setup or is disabled
  # Service should probably be started as well?
  after "deploy:update", "delayed_job:runit:enable"
  after "delayed_job:runit:quit", "delayed_job:runit:stop"

  namespace :delayed_job do
    namespace :runit do
      desc "Setup Delayed Job runit-service"
      task :setup, :roles => :app do
        # Create runit config
        Capistrano::RunitBase.create_service_dir(delayed_job_runit_service_name)
        Capistrano::BaseHelper::generate_and_upload_config(delayed_job_runit_local_config, Capistrano::RunitBase.remote_run_config_path(delayed_job_runit_service_name))
        # must use quit script for stop as well
        # Capistrano::BaseHelper::generate_and_upload_config(delayed_job_runit_control_q, Capistrano::RunitBase.remote_control_path(delayed_job_runit_service_name, "q"))
        # Capistrano::BaseHelper::generate_and_upload_config(delayed_job_runit_control_q, Capistrano::RunitBase.remote_control_path(delayed_job_runit_service_name, "s"))

        # Log run script
        Capistrano::BaseHelper::generate_and_upload_config(delayed_job_runit_local_log_run, Capistrano::RunitBase.remote_service_log_run_path(delayed_job_runit_service_name))

        # Make scripts executable
        Capistrano::RunitBase.make_service_scripts_executeable(delayed_job_runit_service_name)

        # Set correct permissions/owner on log path
        Capistrano::RunitBase.create_and_permissions_on_path(fetch(:delayed_job_log_path))
      end 
      
      desc "Enable Delayed Job runit-service"
      task :enable, :roles => :app do
        Capistrano::RunitBase.enable_service(delayed_job_runit_service_name)
      end

      desc "Disable Delayed Job runit-service"
      task :disable, :roles => :app do
        Capistrano::RunitBase.disable_service(delayed_job_runit_service_name)
      end

      desc "Start Delayed Job runit-service"
      task :start, :roles => :app do
        Capistrano::RunitBase.start_service(delayed_job_runit_service_name)
      end

      desc "Start Delayed Job runit-service only ONCE (no supervision...)"
      task :once, :roles => :app do
        Capistrano::RunitBase.start_service_once(delayed_job_runit_service_name)
      end

      desc "Stop Delayed Job runit-service"
      task :stop, :roles => :app, :on_error => :continue do
        # have to use force-stop on failed stop, since delayed_job might not terminate properly
        # will wait 25 seconds for delayed_job to shut down, to allow it to serve any on-going requests
        Capistrano::RunitBase.control_service(delayed_job_runit_service_name, "force-stop", false, "-w 25")
      end

      desc "Quit the Delayed Job runit-service"
      task :quit, :roles => :app, :on_error => :continue do
        Capistrano::RunitBase.control_service(delayed_job_runit_service_name, "quit")
      end

      desc "Restart Delayed Job runit-service"
      task :restart, :roles => :app do
        Capistrano::RunitBase.control_service(delayed_job_runit_service_name, "restart")
      end
      
      desc "Purge Delayed Job runit configuration"
      task :purge, :roles => :app, :on_error => :continue do
        Capistrano::RunitBase.force_control_service(delayed_job_runit_service_name, "force-stop", true)
        Capistrano::RunitBase.purge_service(delayed_job_runit_service_name)
      end
      
    end
  end
end