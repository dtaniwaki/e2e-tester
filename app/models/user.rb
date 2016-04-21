class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable, :invitable

  has_many :projects, inverse_of: :user
  has_many :user_projects, inverse_of: :user
  has_many :accessible_projects, through: :user_projects, source: :project
  has_many :user_tests, inverse_of: :user
  has_many :accessible_tests, through: :user_tests, source: :test
  has_many :test_step_sets, inverse_of: :user
  has_many :tests, inverse_of: :user
  has_many :shared_test_step_sets, inverse_of: :user
  has_many :test_executions, inverse_of: :user
  has_many :test_execution_browsers, through: :test_executions
  has_many :test_step_executions, through: :test_execution_browsers
  has_many :user_variables, inverse_of: :user
  has_many :user_test_variables, through: :user_tests
  has_many :user_project_variables, through: :user_projects
  has_many :assigned_project_users, class_name: 'UserProject', foreign_key: 'assigned_user_id', inverse_of: :assigned_by
  has_many :assigned_test_users, class_name: 'UserTest', foreign_key: 'assigned_user_id', inverse_of: :assigned_by
  has_many :user_shared_test_step_sets, inverse_of: :user
  has_many :accessible_shared_test_step_sets, through: :user_shared_test_step_sets, source: :shared_test_step_set

  acts_as_paranoid

  validates :email, :confirmation_token, :reset_password_token, :unlock_token, uniqueness: true, allow_blank: true
  validates :email, :encrypted_password, presence: true
  validates :name, length: { minimum: 1, maximum: 100 }, allow_blank: true

  def self.find_or_invite_by(params, user)
    user = User.find_by(params)
    user = User.invite!(params, user) if user.nil?
    user
  end

  def variables(test)
    variables = Hash[*user_variables.map { |v| [v.name, v.value] }.flatten]
    variables.merge! Hash[*user_project_variables.with_project(test.project).map { |v| [v.name, v.value] }.flatten]
    variables.merge! Hash[*user_test_variables.with_test(test).map { |v| [v.name, v.value] }.flatten]
    variables.with_indifferent_access
  end

  def name_or_email
    name.presence || email
  end
end
