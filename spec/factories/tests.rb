FactoryGirl.define do
  factory :test do
    project
    transient do
      browser_count 3
      test_step_count 3
    end
    after :build do |test, evaluator|
      test.test_browsers = build_list(:test_browser, evaluator.browser_count, test: test)
      test.test_steps = build_list(:test_step, evaluator.test_step_count, test: test)
    end
  end
end
