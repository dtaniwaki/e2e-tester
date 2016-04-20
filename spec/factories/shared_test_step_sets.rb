FactoryGirl.define do
  factory :shared_test_step_set do
    user
    title 'foo'
    transient do
      test_steps nil
      test_step_count 3
    end
    after :build do |test, evaluator|
      test.test_steps = if evaluator.test_steps.present?
        evaluator.test_steps
      else
        build_list(:test_step, evaluator.test_step_count, test_step_set: test)
      end
    end
  end
end
