FactoryGirl.define do
  factory :user_test_variable do
    user_test
    sequence(:name) { |n| "foo-#{n}" }
    value 'bar'
  end
end
