FactoryGirl.define do
  factory :test_step, class: TestStep::None do
    association :test_step_set, factory: :test
    factory :navigation_step, class: TestStep::Navigation do
      url 'http://www.example.com/'
    end
    factory :screenshot_step, class: TestStep::Screenshot
    factory :wait_step, class: TestStep::Wait do
      duration 0.5
    end
    factory :resize_window_step, class: TestStep::ResizeWindow do
      width 100
      height 200
    end
    factory :maximize_window_step, class: TestStep::MaximizeWindow
    factory :page_source_step, class: TestStep::PageSource
    factory :step_set_step, class: TestStep::StepSet do
      association :shared_test_step_set, factory: :shared_test_step_set
    end
  end
end
