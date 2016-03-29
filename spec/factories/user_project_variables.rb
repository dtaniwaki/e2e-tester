FactoryGirl.define do
  factory :user_project_variable do
    user_project
    sequence(:name) { |n| "foo-#{n}" }
    value 'bar'
  end
end
