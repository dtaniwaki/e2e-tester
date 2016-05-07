FactoryGirl.define do
  factory :admin_user do
    name 'Foo'
    sequence(:email) { |n| "test-#{n}@example.com" }
    password 'xxxxxxxx'
    password_confirmation 'xxxxxxxx'
  end
end
