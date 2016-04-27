module TestStep
  class Fill < Base
    using Refinements::ReplaceVariables

    validates :selector, length: { minimum: 1, maximum: 255 }, presence: true
    validates :value, length: { minimum: 1, maximum: 255 }, presence: true

    serialized_attribute :selector, :value

    def execute!(_test_step_execution, driver, variables = {})
      value = self.value.replace_variables(variables)
      element = driver.find_element(:css, selector)
      element.clear
      element.send_keys(value)
    end

    def to_line
      %(Fill "#{selector}" with "#{value}")
    end

    def same_step?(other)
      self.class == other.class && selector == other.selector && value == other.selector
    end
  end
end
