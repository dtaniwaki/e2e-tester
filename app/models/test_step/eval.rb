module TestStep
  class Eval < Base
    using Refinements::ReplaceVariables

    validates :javascript, length: { minimum: 1, maximum: 1000 }, presence: true

    serialized_attribute :javascript, :variable

    def execute!(_test_step_execution, driver, variables = {})
      prefix = "e2e-#{SecureRandom.hex(10)}-"
      js = javascript.replace_variables(variables)
      code = <<-EOS
        (function() {
          try {
            #{js};
          } catch(e) {
            return '#{prefix}' + e.message;
          }
        })()
      EOS
      res = driver.execute_script(code)
      if res.to_s =~ /^#{prefix}/
        res.sub!(/^#{prefix}/, '')
        raise E2eTester::JavaScriptError, res
      elsif variable.present?
        variables.merge!(variable => res)
      end
    end

    def to_line
      if variable.present?
        %|Eval #{variable} = (function() { #{javascript} })();|
      else
        %|Eval (function() { #{javascript} })();|
      end
    end

    def same_step?(other)
      self.class == other.class && javascript == other.javascript && variable == other.variable
    end
  end
end
