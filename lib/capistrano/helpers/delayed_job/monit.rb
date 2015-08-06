module Capistrano
  module Helpers
    module DelayedJob
      ##
      # Module Monit provides helpers for Monit/Puma combination
      ##
      module Monit
        module_function

        def pid_file(worker_number)
          service_pid("#{service_name(worker_number)}")
        end

        def service_name(worker_number)
          "#{fetch(:delayed_job_monit_base_service_name)}_#{worker_number}"
        end

        def start_command(worker_number)
          "/bin/bash -c '[ ! -h #{runit_service_path(service_name(worker_number))}/run ] || /usr/bin/sv start #{runit_service_path(service_name(worker_number))}'" # rubocop:disable Metrics/LineLength
        end

        def stop_command(worker_number)
          # Give delayed job 60 seconds to finish any jobs it's currently handling.
          # (Tasks that are longer than 60 seconds should be split!)
          "/usr/bin/sv -w 60 force-stop #{runit_service_path(service_name(worker_number))}" # rubocop:disable Metrics/LineLength
        end

        def available_configuration_with_path(worker_number)
          File.join(fetch(:monit_available_path), "#{service_name(worker_number)}.conf")
        end

        def available_configuration_file(worker_number)
          "#{service_name(worker_number)}.conf"
        end
      end
    end
  end
end
