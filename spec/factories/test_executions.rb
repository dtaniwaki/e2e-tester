FactoryGirl.define do
  factory :test_execution do
    user
    test_version
    transient do
      test_execution_browsers nil
      test_execution_browser_count 2
    end
    after :build do |test_execution, evaluator|
      test_execution.test_execution_browsers = if !evaluator.test_execution_browsers.nil?
        evaluator.test_execution_browsers
      else
        create_list(:test_execution_browser, evaluator.test_execution_browser_count, test_execution: test_execution)
      end
    end
  end
end
