module TestStep
  class Base < ApplicationRecord
    include SerializedAttribute

    self.table_name = 'test_steps'

    belongs_to :test_step_set, inverse_of: :test_steps
    has_many :test_step_executions, inverse_of: :test_step, foreign_key: :test_step_id

    acts_as_list scope: :test_step_set_id

    def self.from_line(_line)
      raise NotImplementedError
    end

    def self.line_regexp
      raise NotImplementedError
    end

    def to_line
      raise NotImplementedError
    end

    def execute!(_execution, _driver, _variables = {})
      raise NotImplementedError
    end

    def attributes
      h = super
      h.merge((h.delete('data') || {}).stringify_keys)
    end

    def screenshot?
      false
    end

    def page_source?
      false
    end

    def same_step?
      false
    end
  end
end
