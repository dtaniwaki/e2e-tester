module UserCredential
  class Browserstack < Base
    belongs_to :user, inverse_of: :browserstack_credential

    serialized_attribute :username, :password

    validates :username, :password, format: { with: /\A[a-zA-Z0-9_-]+\Z/ }, length: { maximum: 100 }, presence: true

    def credential_for?(browser)
      browser.is_a?(Browser::Browserstack)
    end
  end
end
