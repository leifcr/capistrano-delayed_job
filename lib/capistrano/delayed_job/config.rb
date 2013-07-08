require 'capistrano/base_helper/base_helper'
Capistrano::Configuration.instance(true).load do
  _cset :delayed_job_runit_service_name, "delayed_job"
  _cset :delayed_job_workers, 1 # More than 1 is not implemented yet.

  _cset :delayed_job_bin, 'bundle exec rake jobs:work'

  _cset :delayed_job_pid_file,    defer {Capistrano::RunitBase::service_pid(fetch(:delayed_job_runit_service_name))}

  # Logging to path
  _cset :delayed_job_log_path, defer {"/var/log/service/#{fetch(:user)}/#{fetch(:application)}_#{Capistrano::BaseHelper.environment}/delayed_job"}

  # runit defaults
  _cset :delayed_job_restart_interval, defer {fetch(:runit_restart_interval)}
  _cset :delayed_job_restart_count, defer {fetch(:runit_restart_count)}
  _cset :delayed_job_autorestart_clear_interval, defer {fetch(:runit_autorestart_clear_interval)}

    # runit paths
  _cset :delayed_job_runit_local_run,     File.join(File.expand_path(File.join(File.dirname(__FILE__),"../../../templates", "runit", )), "run.erb")
  _cset :delayed_job_runit_local_finish,  File.join(File.expand_path(File.join(File.dirname(__FILE__),"../../../templates", "runit", )), "finish.erb")
  _cset :delayed_job_runit_control_q,     File.join(File.expand_path(File.join(File.dirname(__FILE__),"../../../templates", "runit")), "control-q.erb")
  _cset :delayed_job_runit_local_log_run, File.join(File.expand_path(File.join(File.dirname(__FILE__),"../../../templates", "runit")), "log-run.erb")

  # monit configuration
  _cset :delayed_job_monit_service_name,  defer { "#{fetch(:user)}_#{fetch(:application)}_#{Capistrano::BaseHelper.environment}_delayed_job" }
  _cset :delayed_job_monit_start_command, defer {"/bin/bash -c '[ ! -h #{Capistrano::RunitBase.service_path(fetch(:delayed_job_runit_service_name))}/run ] || /usr/bin/sv start #{Capistrano::RunitBase.service_path(fetch(:delayed_job_runit_service_name))}'"}
  _cset :delayed_job_monit_stop_command,  defer {"/usr/bin/sv -w 12 force-stop #{Capistrano::RunitBase.service_path(fetch(:delayed_job_runit_service_name))}"}
  _cset :delayed_job_monit_memory_alert_threshold, "45.0 MB for 2 cycles"
  _cset :delayed_job_monit_memory_restart_threshold, "50.0 MB for 3 cycles"
  _cset :delayed_job_monit_cpu_alert_threshold,   "90% for 2 cycles"
  _cset :delayed_job_monit_cpu_restart_threshold, "95% for 5 cycles"

  _cset :delayed_job_local_monit_config, File.join(File.expand_path(File.join(File.dirname(__FILE__),"../../../templates", "monit")), "delayed_job.conf.erb")

end