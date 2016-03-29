FactoryGirl.define do
  factory :screenshot do
    test_step { create :screenshot_step }
    test_step_execution
  end
end
