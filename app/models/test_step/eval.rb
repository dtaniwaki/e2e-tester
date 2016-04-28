module TestStep
  class Eval < Base
    using Refinements::ReplaceVariables

    validates :javascript, length: { minimum: 1, maximum: 1000 }, presence: true

    serialized_attribute :javascript

    def execute!(_test_step_execution, driver, _variables = {})
      code = <<-EOS
        try {
          #{javascript}
          return nil;
        } catch(e) {
          return e.message;
        }
      EOS
      res = driver.execute_script(code)
      raise "JavaScript Error: #{res}" unless res.nil?
    end

    def to_line
      %(Eval #{javascript})
    end

    def same_step?(other)
      self.class == other.class && javascript == other.javascript
    end
  end
end
