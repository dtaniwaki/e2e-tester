class TestExecutionShare < ApplicationRecord
  belongs_to :user, inverse_of: :test_execution_shares
  belongs_to :test_execution, inverse_of: :test_execution_shares

  validates :token, uniqueness: true, presence: true
  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :expire_at, timeliness: { type: :datetime, after: -> { Time.zone.now } }, allow_blank: true

  before_validation :assign_token

  scope :valid, -> { where("#{table_name}.expire_at IS NULL OR #{table_name}.expire_at > ?", Time.zone.now) }

  private

  def assign_token
    10.times do
      token = SecureRandom.hex(16)
      unless TestExecutionShare.where(token: token).exists?
        self.token = token
        return
      end
    end
    raise 'Can not assign a token'
  end
end
