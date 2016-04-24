FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |n| "test-#{n}@example.com" }
    encrypted_password 'xxxxxxxx'
    name 'Foo'
    provider 'google'
    uid 'bar'
  end
end
