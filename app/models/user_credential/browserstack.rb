module UserCredential
  class Browserstack < Base
    belongs_to :user, inverse_of: :browserstack_credential

    serialized_attribute :username, :password

    validates :username, :password, presence: true

    def credential_for?(browser)
      browser.is_a?(Browser::Browserstack)
    end
  end
end
