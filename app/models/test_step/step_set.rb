module TestStep
  class StepSet < Base
    belongs_to :shared_test_step_set, class_name: 'SharedTestStepSet', inverse_of: :test_steps
    has_many :test_steps, through: :shared_test_step_set

    def execute!(test_step_execution, driver, variables = {})
      test_execution_browser = test_step_execution.test_execution_browser
      executions = test_steps.map do |ts|
        test_execution_browser.test_step_executions.eager_load(:test_step).find_or_create_by(test_step_id: ts.id)
      end
      executions.each do |tse|
        tse.execute!(driver, variables)
      end
      # TODO: Use custom exception class
      raise 'Some of the test steps failed' if executions.any?(&:failed?)
    end

    # FIXME: temporary implementation
    def to_line
      %(SharedTestStepSet #{shared_test_step_set_id})
    end

    # FIXME: temporary implementation
    def self.from_line(line)
      new(shared_test_step_set_id: Regexp.last_match(1)) if line =~ line_regexp
    end

    def self.line_regexp
      /^SharedTestStepSet (.*)$/i
    end

    def same_step?(other)
      self.class == other.class && shared_test_step_set_id == other.shared_test_step_set_id
    end
  end
end
