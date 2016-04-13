class Project < ApplicationRecord
  belongs_to :user, inverse_of: :projects
  has_many :user_projects, inverse_of: :project, dependent: :destroy
  has_many :tests, inverse_of: :project, dependent: :destroy

  acts_as_paranoid

  validates :title, length: { maximum: 255 }, presence: true

  after_create :assign_owner!

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, ->(user) { joins(:user_projects).merge(UserProject.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }

  private

  def assign_owner!
    user_projects.create!(user: user)
  end
end
