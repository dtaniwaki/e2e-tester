class UserApiToken < ApplicationRecord
  include GenerateTokenConcern

  belongs_to :user, inverse_of: :user_api_tokens

  generate_token :token

  validates :name, length: { maximum: 100 }, presence: true
  validates :token, uniqueness: true, presence: true
end
