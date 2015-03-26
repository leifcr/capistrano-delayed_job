module Capistrano
  module Helpers
    module DelayedJob
      ##
      # Paths for templates
      #
      module TemplatePaths
        module_function

        def template_base_path
          File.expand_path(File.join(File.dirname(__FILE__), '../../../../templates'))
        end
      end
    end
  end
end
