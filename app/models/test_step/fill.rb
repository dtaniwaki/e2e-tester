module TestStep
  class Fill < Base
    using Refinements::ReplaceVariables

    validates :selector, length: { minimum: 1, maximum: 255 }, presence: true
    validates :value, length: { minimum: 1, maximum: 255 }, presence: true

    serialized_attribute :selector, :value

    def execute!(_test_step_execution, driver, variables = {})
      value = self.value.replace_variables(variables)
      driver.find_element(:css, selector).send_keys(value)
    end

    # FIXME: temporary implementation
    def to_line
      %(Fill "#{selector}" with "#{value}")
    end

    # FIXME: temporary implementation
    def self.from_line(line)
      new(selector: Regexp.last_match(1), value: Regexp.last_match(2)) if line =~ line_regexp
    end

    def self.line_regexp
      /^fill "([^"]*)" with "([^"]*)"/i
    end

    def same_step?(other)
      self.class == other.class && selector == other.selector && value == other.selector
    end
  end
end
