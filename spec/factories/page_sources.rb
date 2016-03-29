FactoryGirl.define do
  factory :page_source do
    test_step { create :page_source_step }
    test_step_execution
  end
end
