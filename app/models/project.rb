class Project < ApplicationRecord
  belongs_to :user, inverse_of: :projects
  belongs_to :current_test, class_name: 'Test', foreign_key: :current_test_id
  has_many :user_projects, inverse_of: :project
  has_many :tests, inverse_of: :project
  has_many :updating_tests, -> { where(id: nil) }, class_name: 'Test'

  acts_as_paranoid

  after_create :assign_owner!

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, ->(user) { joins(:user_projects).merge(UserProject.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }

  delegate :title, :description, to: :current_test, allow_nil: true

  accepts_nested_attributes_for :updating_tests, allow_destroy: false, reject_if: :curret_test_same_as?

  def updating_test
    updating_tests.first || current_test || updating_tests.build
  end

  private

  def curret_test_same_as?(attributes)
    new_test = Test.new(attributes)
    new_test.nilify_blanks
    new_test.same_test_step_set?(current_test)
  end

  def assign_owner!
    user_projects.create!(user: user)
  end
end
