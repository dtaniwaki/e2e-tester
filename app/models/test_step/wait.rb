module TestStep
  class Wait < Base
    validates :duration, numericality: { greater_than: 0, less_than_or_equal_to: 10 }, presence: true

    serialized_attribute :duration, type: :float

    def execute!(_test_step_execution, _driver, _variables = {})
      sleep duration
    end

    def to_line
      "Wait for #{duration} seconds"
    end

    def same_step?(other)
      self.class == other.class && duration == other.duration
    end
  end
end
