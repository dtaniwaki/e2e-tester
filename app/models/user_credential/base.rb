module UserCredential
  class Base < ApplicationRecord
    include SerializedAttribute

    self.table_name = 'user_credentials'

    belongs_to :user, inverse_of: :user_credentials

    def credential_for?(_browser)
      false
    end
  end
end
