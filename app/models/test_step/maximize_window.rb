module TestStep
  class MaximizeWindow < Base
    def execute!(_test_step_execution, driver, _variables = {})
      driver.manage.window.maximize
      driver.execute_script('window.scrollTo(0, 0)')
    end

    def to_line
      'Maximize window'
    end

    def same_step?(other)
      self.class == other.class
    end
  end
end
