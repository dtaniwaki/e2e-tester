FactoryGirl.define do
  factory :test_execution_share do
    user
    test_execution
    name 'Foo'
  end
end
