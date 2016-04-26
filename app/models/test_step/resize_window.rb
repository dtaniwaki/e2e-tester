module TestStep
  class ResizeWindow < Base
    validates :width, :height, format: { with: /\A\d+%?\Z/ }, allow_nil: true

    serialized_attribute :width, :height, type: :integer

    def execute!(_test_step_execution, driver, _variables = {})
      width = self.width
      height = self.height

      if width.to_s =~ /%$/ || height.to_s =~ /%$/
        driver.manage.window.maximize
        size = driver.manage.window.size
        width = size[0].to_f * Regexp.last_match(1).to_i / 100 if width.to_s =~ /(\d+)%$/
        height = size[1].to_f * Regexp.last_match(1).to_i / 100 if height.to_s =~ /(\d+)%$/
      end
      if width.nil? || height.nil?
        size = driver.manage.window.size
        width = size[0] if width.nil?
        height = size[1] if height.nil?
      end

      driver.manage.window.resize_to(width, height)
      driver.execute_script('window.scrollTo(0, 0)')
    end

    def to_line
      "Resize window to #{width}x#{height}"
    end

    def same_step?(other)
      self.class == other.class && width == other.width && height == other.height
    end
  end
end
