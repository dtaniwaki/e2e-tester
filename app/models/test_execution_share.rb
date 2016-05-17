class TestExecutionShare < ApplicationRecord
  include GenerateTokenConcern

  belongs_to :user, inverse_of: :test_execution_shares
  belongs_to :test_execution, inverse_of: :test_execution_shares

  validates :token, uniqueness: true, presence: true
  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :expire_at, timeliness: { type: :datetime, after: -> { Time.zone.now } }, allow_blank: true

  generate_token :token

  scope :available, -> { where("#{table_name}.expire_at IS NULL OR #{table_name}.expire_at > ?", Time.zone.now) }

  alias_attribute :shared_at, :created_at

  def available?
    expire_at.nil? || expire_at > Time.zone.now
  end
end
