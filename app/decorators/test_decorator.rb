class TestDecorator < Draper::Decorator
  delegate_all
  decorates_association :base_test_step_set

  def title
    object.title || "#{object.project.title} ##{object.id}"
  end
end
