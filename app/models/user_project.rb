class UserProject < ApplicationRecord
  belongs_to :user, inverse_of: :accessible_projects
  belongs_to :assigned_by, class_name: 'User', foreign_key: 'assigned_by_id', inverse_of: :assigned_project_users
  belongs_to :project, inverse_of: :user_projects
  has_many :user_project_variables, inverse_of: :user_project

  scope :with_user, ->(user) { where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user) }
  scope :with_project, ->(project) { where(project_id: project.is_a?(ActiveRecord::Base) ? project.id : project) }

  after_commit :send_notification!, on: :create, if: ->(ut) { ut.assigned_by.present? }

  accepts_nested_attributes_for :user_project_variables, allow_destroy: true

  def send_notification!
    UserMailer.assigned_project(self).deliver_now!
  end
end
