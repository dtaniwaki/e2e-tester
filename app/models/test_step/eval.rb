module TestStep
  class Eval < Base
    using Refinements::ReplaceVariables

    validates :javascript, length: { minimum: 1, maximum: 1000 }, presence: true

    serialized_attribute :javascript

    def execute!(_test_step_execution, driver, variables = {})
      prefix = "e2e-#{SecureRandom.hex(10)}-"
      js = javascript
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
        raise "JavaScript Error: #{res}"
      end

      nil
    end

    def to_line
      %(Eval #{javascript})
    end

    def same_step?(other)
      self.class == other.class && javascript == other.javascript
    end
  end
end
