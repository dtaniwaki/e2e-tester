module TestStep
  class StepSet < Base
    belongs_to :shared_test_step_set, inverse_of: :test_step_sets
    has_many :test_steps, through: :shared_test_step_set

    scope :with_test_step_set, ->(test_step_set) { where(shared_test_step_set_id: test_step_set.is_a?(ActiveRecord::Base) ? test_step_set.id : test_step_set) }

    validate :validate_accessibility
    validates :shared_test_step_set, presence: true

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

    def to_line
      shared_test_step_set&.title
    end

    def same_step?(other)
      self.class == other.class && shared_test_step_set_id == other.shared_test_step_set_id
    end

    private

    def validate_accessibility
      return if test_step_set.base_test_step_set&.test_step_sets&.with_test_step_set(shared_test_step_set)&.exists?
      return if shared_test_step_set&.user_shared_test_step_sets&.with_user(test_step_set.user)&.exists?
      errors.add :shared_test_step_set_id, :invalid
    end
  end
end
