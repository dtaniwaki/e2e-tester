class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable, :invitable, :lockable

  has_many :tests, inverse_of: :user
  has_many :user_tests, inverse_of: :user
  has_many :accessible_tests, through: :user_tests, source: :test
  has_many :user_test_versions, inverse_of: :user
  has_many :accessible_test_versions, through: :user_test_versions, source: :test_version
  has_many :test_step_sets, inverse_of: :user
  has_many :test_versions, inverse_of: :user
  has_many :shared_test_step_sets, inverse_of: :user
  has_many :test_executions, inverse_of: :user
  has_many :test_execution_browsers, through: :test_executions
  has_many :test_step_executions, through: :test_execution_browsers
  has_many :user_variables, inverse_of: :user
  has_many :user_test_version_variables, through: :user_test_versions
  has_many :user_test_variables, through: :user_tests
  has_many :assigned_test_users, class_name: 'UserTest', foreign_key: 'assigned_user_id', inverse_of: :assigned_by
  has_many :assigned_test_version_users, class_name: 'UserTestVersion', foreign_key: 'assigned_user_id', inverse_of: :assigned_by
  has_many :user_shared_test_step_sets, inverse_of: :user
  has_many :accessible_shared_test_step_sets, through: :user_shared_test_step_sets, source: :shared_test_step_set
  has_many :user_credentials, class_name: 'UserCredential::Base', inverse_of: :user
  has_one :browserstack_credential, class_name: 'UserCredential::Browserstack', inverse_of: :user
  has_many :user_integrations, class_name: 'UserIntegration::Base', inverse_of: :user
  has_many :test_execution_shares, inverse_of: :user
  has_many :user_api_tokens, inverse_of: :user

  acts_as_paranoid

  validates :email, :confirmation_token, :reset_password_token, :unlock_token, uniqueness: true, allow_blank: true
  validates :email, :encrypted_password, presence: true
  validates :name, :username, presence: true, if: -> (u) { u.accepted_or_not_invited? || u.accepting_invitation? }
  validates :name, length: { minimum: 1, maximum: 100 }, allow_blank: true
  validates :username,
            format: { with: /\A([a-zA-Z0-9_][a-zA-Z0-9_\-\.]*[a-zA-Z0-9_]|[a-zA-Z0-9_])\Z/ },
            length: { minimum: 1, maximum: 20 },
            uniqueness: { case_sensitive: false },
            allow_blank: true

  accepts_nested_attributes_for :user_variables, allow_destroy: true, reject_if: -> (attributes) { attributes[:name].blank? && attributes[:value].blank? }

  def self.find_or_invite_by(params, user)
    user = User.find_by(params)
    user = User.invite!(params, user) if user.nil?
    user
  end

  def variables(test_version)
    variables = Hash[*user_variables.map { |v| [v.name, v.value] }.flatten]
    variables.merge! Hash[*user_test_variables.with_test(test_version.test).map { |v| [v.name, v.value] }.flatten]
    variables.merge! Hash[*user_test_version_variables.with_test_version(test_version).map { |v| [v.name, v.value] }.flatten]
    variables.with_indifferent_access
  end

  def name_or_email
    name.presence || email
  end
end
