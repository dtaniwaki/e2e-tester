FactoryGirl.define do
  factory :browserstack_credential, class: 'UserCredential::Browserstack' do
    user
    username 'foo'
    password 'bar'
  end
end
