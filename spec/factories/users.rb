FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "dtaniwaki-#{n}" }
    name 'Daisuke Taniwaki'
    sequence(:email) { |n| "foo-#{n}@example.com" }
    password Devise.friendly_token(8)
    password_confirmation { password }
    confirmed_at 0.days.ago
  end
end
