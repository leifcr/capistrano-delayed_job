module Capistrano
  module Helpers
    module DelayedJob
      ##
      # Module Monit provides helpers for Monit/Puma combination
      ##
      module Runit
        module_function

        def delayed_job_runit_service_name(worker_number)
          "#{fetch(:delayed_job_runit_base_service_name)}_#{worker_number}"
        end

        def delayed_job_log_path(worker_number)
          runit_var_log_service_single_service_path(delayed_job_runit_service_name(worker_number))
        end

        def available_configuration_with_path(worker_number)
          File.join(fetch(:monit_available_path), "#{fetch(:delayed_job_runit_service_name)}_#{worker_number}.conf")
        end

        def available_configuration_file(worker_number)
          "#{fetch(:delayed_job_runit_service_name)}_#{worker_number}.conf"
        end
      end
    end
  end
end
