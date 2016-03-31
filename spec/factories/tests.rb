FactoryGirl.define do
  factory :test do
    project
    transient do
      browsers nil
      browser_count 3
      test_step_count 3
    end
    after :build do |test, evaluator|
      if evaluator.browsers.present?
        test.browsers = evaluator.browsers
      else
        test.browsers = create_list(:browser, evaluator.browser_count)
      end
      test.test_steps = build_list(:test_step, evaluator.test_step_count, test: test)
    end
    trait :with_parent do
      parent { create :test }
    end
  end
end
