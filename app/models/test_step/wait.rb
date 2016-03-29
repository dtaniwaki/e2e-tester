module TestStep
  class Wait < Base
    validates :duration, numericality: { greater_than: 0, less_than_or_equal_to: 10 }, presence: true

    serialized_attribute :duration

    def execute!(_test_step_execution, _driver, _variables = {})
      sleep duration
    end

    # FIXME: temporary implementation
    def to_line
      "Wait for #{duration} seconds"
    end

    # FIXME: temporary implementation
    def self.from_line(line)
      new(duration: Regexp.last_match(1).to_f) if line =~ line_regexp
    end

    def self.line_regexp
      /^wait for (\d+(.\d+)?) sec(ond(s)?)?/i
    end

    def same_step?(other)
      self.class == other.class && duration == other.duration
    end
  end
end
