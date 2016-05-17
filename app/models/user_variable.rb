class UserVariable < ApplicationRecord
  belongs_to :user, inverse_of: :user_variables

  validates :name, :value, length: { minimum: 0, maximum: 255 }, allow_nil: true
  validates :name, uniqueness: { scope: [:user_id] }, presence: true

  validates_with SimilarRecordValidator, count: 10, conditions: [:user_id]
end
