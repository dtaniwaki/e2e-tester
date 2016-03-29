class UserProjectVariable < ApplicationRecord
  belongs_to :user_project, inverse_of: :user_project_variables

  scope :with_user, ->(user) { joins(:user_project).merge(UserProject.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }
  scope :with_project, ->(project) { joins(:user_project).merge(UserProject.where(project_id: project.is_a?(ActiveRecord::Base) ? project.id : project)) }

  validates :name, :value, length: { minimum: 0, maximum: 255 }, allow_nil: true
  validates :name, uniqueness: { scope: [:user_project_id] }, presence: true
end
