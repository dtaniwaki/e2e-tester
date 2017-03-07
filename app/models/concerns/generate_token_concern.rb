module GenerateTokenConcern
  extend ActiveSupport::Concern

  included do
    before_validation :assign_token, on: :create
    class_attribute :token_columns
  end

  module ClassMethods
    def generate_token(*column_name)
      self.token_columns ||= Set.new
      self.token_columns += column_name.map(&:to_s).flatten
    end
  end

  def assign_token
    token_columns.each do |column_name|
      10.times do
        token = SecureRandom.urlsafe_base64(32)
        unless TestExecutionShare.where(column_name => token).exists?
          self[column_name] ||= token
          break
        end
      end
      raise E2eTester::GenerateTokenFailure, "Can not assign a token on #{column_name}" if self[column_name].nil?
    end
  end
end
