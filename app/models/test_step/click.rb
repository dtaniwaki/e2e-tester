module TestStep
  class Click < Base
    using Refinements::ReplaceVariables

    validates :selector, length: { minimum: 1, maximum: 255 }, presence: true

    serialized_attribute :selector

    def execute!(_test_step_execution, driver, _variables = {})
      driver.find_element(:css, selector).click
    end

    def to_line
      %(Click "#{selector}")
    end

    def same_step?(other)
      self.class == other.class && selector == other.selector
    end
  end
end
