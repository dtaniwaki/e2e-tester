class Test < ApplicationRecord
  belongs_to :user, inverse_of: :tests
  belongs_to :current_test_version, class_name: 'TestVersion', foreign_key: :current_test_version_id
  has_many :user_tests, inverse_of: :test
  has_many :test_versions, inverse_of: :test
  has_many :updating_test_versions, -> { where(id: nil) }, class_name: 'TestVersion', inverse_of: :test
  has_many :accessible_users, through: :user_tests, source: :user

  acts_as_paranoid

  after_create :assign_owner!

  scope :with_user, ->(user) { joins(:user_tests).merge(UserTest.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }

  delegate :title, :description, to: :current_test_version, allow_nil: true

  accepts_nested_attributes_for :updating_test_versions, allow_destroy: false, reject_if: :curret_test_version_same_as?

  def updating_test_version
    updating_test_versions.first || current_test_version || updating_test_versions.build
  end

  private

  def curret_test_version_same_as?(attributes)
    new_version = TestVersion.new(attributes)
    new_version.nilify_blanks
    new_version.base_test_step_set = current_test_version
    new_version.same_test_step_set?(current_test_version)
  end

  def assign_owner!
    user_tests.create!(user: user)
  end
end
