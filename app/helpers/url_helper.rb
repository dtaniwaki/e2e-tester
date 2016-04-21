module UrlHelper
  include Rails.application.routes.url_helpers

  def polymorphic_test_step_set_path(test_step_set, options = {})
    if test_step_set.is_a?(Test)
      test_path(test_step_set, options)
    elsif test_step_set.is_a?(SharedTestStepSet)
      test_step_set_path(test_step_set, options)
    else
      raise NotImplementedError
    end
  end
end
