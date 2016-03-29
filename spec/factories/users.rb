FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foo-#{n}@example.com" }
    password Devise.friendly_token(8)
    password_confirmation { password }
  end
end
