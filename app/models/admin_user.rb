class AdminUser < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :comments, as: :commenter, inverse_of: :commenter

  validates :email, format: { with: /\A#{Settings.admin.email_format}\Z/ }
  validates :name, :email, :provider, :uid, :encrypted_password, presence: true
  validates :email, :provider, :uid, :name, :token, length: { maximum: 255 }

  attr_accessor :password, :password_confirmation

  def self.find_for_google_oauth2(auth, _signed_in_resource = nil)
    data = auth.info

    user = find_by(email: data['email'])
    if user.present?
      user.save! # To validate the record with latest validations
    else
      user = create!(
        name: data['name'],
        email: data['email'],
        provider: auth.provider,
        uid: auth.uid,
        encrypted_password: Devise.friendly_token[0, 20]
      )
    end

    user
  end
end
