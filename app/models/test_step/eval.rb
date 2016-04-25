module TestStep
  class Eval < Base
    using Refinements::ReplaceVariables

    validates :javascript, length: { minimum: 1, maximum: 1000 }, presence: true

    serialized_attribute :javascript

    def execute!(_test_step_execution, driver, _variables = {})
      driver.execute_script(javascript)
    end

    def to_line
      %(Eval #{javascript})
    end

    def same_step?(other)
      self.class == other.class && javascript == other.javascript
    end
  end
end
