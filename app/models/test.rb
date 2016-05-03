class Test < TestStepSet
  belongs_to :project, inverse_of: :tests
  has_many :user_tests, inverse_of: :test
  has_many :test_executions, inverse_of: :test
  has_many :test_browsers, inverse_of: :test
  has_many :browsers, through: :test_browsers

  scope :with_user, ->(user) { joins(:user_tests).merge(UserTest.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }

  after_create :assign_current_test!

  validates :title, presence: true
  validates :browsers, length: { minimum: 1, maximum: 10 }, allow_blank: true
  validate :validate_same_test

  def same_test_step_set?(other)
    super &&
      (other.respond_to?(:browser_ids) && browser_ids == other.browser_ids)
  end

  def executable?
    browsers.present? && test_steps.present?
  end

  private

  def validate_same_test
    errors.add :base, 'The test is the same as the base test' if base_test_step_set && same_test_step_set?(base_test_step_set)
  end

  def assign_current_test!
    project.current_test = self
    project.save!
  end
end
