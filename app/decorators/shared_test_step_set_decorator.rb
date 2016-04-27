class SharedTestStepSetDecorator < Draper::Decorator
  delegate_all
  decorates_association :base_test_step_set
end
