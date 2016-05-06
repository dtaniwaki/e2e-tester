module AutoDecorate
  extend ActiveSupport::Concern

  module ClassMethods
    def auto_decorate(*variables)
      options = variables.extract_options!
      only = options[:only]&.map(&:to_s) || []
      except = options[:except]&.map(&:to_s) || []
      define_method :render do |*args|
        variables.each do |variable|
          decorated = "@#{variable}"

          next unless instance_variable_defined?(decorated)
          next if decorated.nil?
          if only.include?(action_name) && !except.include?(action_name)
            instance_variable_set decorated, instance_variable_get(decorated).decorate
          end
        end
        super(*args)
      end
    end
  end
end
