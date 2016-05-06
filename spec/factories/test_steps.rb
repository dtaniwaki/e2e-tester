FactoryGirl.define do
  factory :test_step, class: TestStep::None do
    test_step_type 'none'
    association :test_step_set, factory: :test_version
    factory :navigation_step, class: TestStep::Navigation do
      test_step_type 'navigation'
      url 'http://www.example.com/'
    end
    factory :screenshot_step, class: TestStep::Screenshot do
      test_step_type 'screenshot'
    end
    factory :wait_step, class: TestStep::Wait do
      test_step_type 'wait_step'
      duration 0.5
    end
    factory :resize_window_step, class: TestStep::ResizeWindow do
      test_step_type 'resize_window'
      width 100
      height 200
    end
    factory :maximize_window_step, class: TestStep::MaximizeWindow do
      test_step_type 'maximize_window'
    end
    factory :page_source_step, class: TestStep::PageSource do
      test_step_type 'page_source'
    end
    factory :step_set_step, class: TestStep::StepSet do
      test_step_type 'step_set'
      shared_test_step_set { create :shared_test_step_set, user: test_step_set.user }
    end
  end
end
