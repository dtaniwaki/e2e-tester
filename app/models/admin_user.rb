class AdminUser < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable, :lockable

  has_many :comments, as: :commenter, inverse_of: :commenter

  acts_as_paranoid

  validates :name, :email, :encrypted_password, length: { maximum: 255 }, presence: true
  validates :email, :confirmation_token, :reset_password_token, :unlock_token, uniqueness: true, allow_blank: true
end
