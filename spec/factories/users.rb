FactoryGirl.define do
  factory :user do
    name 'username'
    sequence(:email) { |n| "foo-#{n}@example.com" }
    password Devise.friendly_token(8)
    password_confirmation { password }
    confirmed_at 0.days.ago
  end
end
