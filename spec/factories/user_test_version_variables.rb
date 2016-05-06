FactoryGirl.define do
  factory :user_test_version_variable do
    user_test_version
    sequence(:name) { |n| "foo-#{n}" }
    value 'bar'
  end
end
