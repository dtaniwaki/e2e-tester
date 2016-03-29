module TestStep
  class None < Base
    serialized_attribute :message

    def self.from_line(line)
      new(message: Regexp.last_match(2)) if line =~ line_regexp
    end

    def self.line_regexp
      /^none( (.*))?$/i
    end

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
