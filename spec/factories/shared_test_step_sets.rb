FactoryGirl.define do
  factory :shared_test_step_set do
    user
    title 'foo'
    transient do
      test_steps nil
      test_step_count 3
      test_steps_attributes nil
    end
    after :build do |test, evaluator|
      if !evaluator.test_steps_attributes.nil?
        test.test_steps_attributes = evaluator.test_steps_attributes
      else
        test.test_steps = if !evaluator.test_steps.nil?
          evaluator.test_steps
        else
          build_list(:test_step, evaluator.test_step_count, test_step_set: test)
        end
      end
    end
  end
end
