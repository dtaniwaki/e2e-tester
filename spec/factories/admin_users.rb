FactoryGirl.define do
  factory :admin_user do
    email 'test@example.com'
    encrypted_password 'xxxxxxxx'
    name 'Foo'
    provider 'google'
    uid 'bar'
  end
end
