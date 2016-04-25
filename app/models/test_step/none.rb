module TestStep
  class None < Base
    serialized_attribute :message

    def to_line
      s = 'None'
      s += " #{message}" if message.present?
      s
    end

    def execute!(execution, driver, variables = {})
      # DO NOTHING
    end

    def same_step?(other)
      self.class == other.class && message == other.message
    end
  end
end
