FactoryGirl.define do
  factory :user_variable do
    user
    sequence(:name) { |n| "foo-#{n}" }
    value 'bar'
  end
end
