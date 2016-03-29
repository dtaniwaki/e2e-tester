module TestStep
  class MaximizeWindow < Base
    def execute!(_test_step_execution, driver, _variables = {})
      driver.manage.window.maximize
      driver.execute_script('window.scrollTo(0, 0)')
    end

    # FIXME: temporary implementation
    def to_line
      'Maximize window'
    end

    # FIXME: temporary implementation
    def self.from_line(line)
      new if line =~ line_regexp
    end

    def self.line_regexp
      /^maximize window/i
    end

    def same_step?(other)
      self.class == other.class
    end
  end
end
