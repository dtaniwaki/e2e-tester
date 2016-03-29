module TestStep
  class Eval < Base
    using Refinements::ReplaceVariables

    validates :javascript, length: { minimum: 1, maximum: 1000 }, presence: true

    serialized_attribute :javascript

    def execute!(_test_step_execution, driver, _variables = {})
      driver.execute_script(javascript)
    end

    # FIXME: temporary implementation
    def to_line
      %(Eval #{javascript})
    end

    # FIXME: temporary implementation
    def self.from_line(line)
      new(javascript: Regexp.last_match(1)) if line =~ line_regexp
    end

    def self.line_regexp
      /^eval (.*)$/i
    end

    def same_step?(other)
      self.class == other.class && javascript == other.javascript
    end
  end
end
