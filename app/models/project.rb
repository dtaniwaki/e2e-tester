class Project < ApplicationRecord
  belongs_to :user, inverse_of: :own_projects
  belongs_to :current_test, class_name: 'Test', foreign_key: 'test_id', inverse_of: :active_projects
  has_many :user_projects, inverse_of: :project, dependent: :destroy
  has_many :tests, inverse_of: :project, dependent: :destroy

  acts_as_paranoid

  validates :title, length: { maximum: 255 }, presence: true
  validates :current_test, presence: true

  accepts_nested_attributes_for :current_test, allow_destroy: false, update_only: false

  after_create :assign_owner!

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, ->(user) { joins(:user_projects).merge(UserProject.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }

  def current_test=(test)
    return current_test if current_test.present? && test.present? && current_test.same_test?(test)
    super test
  end

  private

  def assign_owner!
    user_projects.create!(user: user)
  end
end
