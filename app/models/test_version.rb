class TestVersion < TestStepSet
  belongs_to :user, inverse_of: :test_versions
  belongs_to :test, inverse_of: :test_versions
  has_many :user_test_versions, inverse_of: :test_version
  has_many :test_executions, inverse_of: :test_version
  has_many :test_browsers, inverse_of: :test_version
  has_many :browsers, through: :test_browsers

  scope :with_user, ->(user) { joins(:user_test_versions).merge(UserTestVersion.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }
  scope :with_test, ->(test) { where(test_id: test.is_a?(ActiveRecord::Base) ? test.id : test) }
  scope :without_deleted, -> { joins(:test).merge(Test.without_deleted) }

  after_create :assign_current_test_version!

  acts_as_list scope: :test_id

  validates :test, presence: true
  validates :title, presence: true
  validates :browsers, length: { minimum: 1, maximum: 10 }, allow_blank: true
  validate :validate_same_test_version

  def same_test_step_set?(other)
    super &&
      (other.respond_to?(:browser_ids) && browser_ids == other.browser_ids)
  end

  def executable?
    browsers.present? && test_steps.present?
  end

  private

  def validate_same_test_version
    errors.add :base, 'The test is the same as the base test' if base_test_step_set && same_test_step_set?(base_test_step_set)
  end

  def assign_current_test_version!
    test.current_test_version = self
    test.save!
  end
end
