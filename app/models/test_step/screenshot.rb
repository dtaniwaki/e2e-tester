module TestStep
  class Screenshot < Base
    include WebDriverExt::FullScreenshot

    has_many :screenshots, inverse_of: :test_step, class_name: '::Screenshot', foreign_key: 'test_step_id'

    def execute!(test_step_execution, driver, _variables = {})
      screenshots.find_or_create_by(test_step_execution_id: test_step_execution.id).update_attributes!(image: take_full_screenshot(driver))
    end

    def to_line
      'Take screenshot'
    end

    def screenshot?
      true
    end

    def same_step?(other)
      self.class == other.class
    end
  end
end
