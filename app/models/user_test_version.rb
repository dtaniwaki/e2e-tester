class UserTestVersion < ApplicationRecord
  belongs_to :user, inverse_of: :accessible_test_versions
  belongs_to :assigned_by, class_name: 'User', foreign_key: 'assigned_by_id', inverse_of: :assigned_test_version_users
  belongs_to :test_version, inverse_of: :user_test_versions
  has_many :user_test_version_variables, inverse_of: :user_test_version, dependent: :destroy
  has_one :test, through: :test_version

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, ->(user) { where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user) }
  scope :with_test_version, ->(test_version) { where(test_version_id: test_version.is_a?(ActiveRecord::Base) ? test_version.id : test_version) }

  after_commit :send_notification!, on: :create, if: ->(ut) { ut.assigned_by.present? }

  accepts_nested_attributes_for :user_test_version_variables, allow_destroy: true, reject_if: -> (attributes) { attributes[:name].blank? && attributes[:value].blank? }

  alias_attribute :assigned_at, :created_at

  def send_notification!
    UserMailer.assigned_test_version(user, test_version).deliver_now!
  end
end
