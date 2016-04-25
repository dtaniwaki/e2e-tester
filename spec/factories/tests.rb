FactoryGirl.define do
  factory :test do
    user
    title 'foo'
    transient do
      browsers nil
      browser_count 3
      test_steps nil
      test_step_count 3
      test_steps_attributes nil
    end
    after :build do |test, evaluator|
      test.project ||= create :project
      test.browsers = if evaluator.browsers.present?
        evaluator.browsers
      else
        create_list(:browser, evaluator.browser_count)
      end
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
