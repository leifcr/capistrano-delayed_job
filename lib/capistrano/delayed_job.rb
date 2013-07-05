def try_require(library)
  begin
    require "#{library}"
  rescue LoadError => e
    puts "Capistrano-Delayed Job: Cannot load library: #{library} Error: #{e}"
  end
end

try_require 'capistrano/delayed_job/config'
try_require 'capistrano/delayed_job/runit'
try_require 'capistrano/delayed_job/monit'
