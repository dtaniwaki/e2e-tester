module TestStep
  class Base < ApplicationRecord
    include SerializedAttribute

    self.table_name = 'test_steps'

    belongs_to :test_step_set, inverse_of: :test_steps
    has_many :test_step_executions, inverse_of: :test_step, foreign_key: :test_step_id

    validates :type, presence: true
    validate :validate_as_subclass

    acts_as_list scope: :test_step_set_id

    # Avoid malicious attack on type column
    def test_step_type=(s)
      s = "TestStep::#{s.camelize}"
      becomes! s.constantize if TestStep.steps.map(&:to_s).include?(s)
    end

    def test_step_type
      type&.demodulize&.underscore
    end

    def to_line
      raise NotImplementedError
    end

    def execute!(_execution, _driver, _variables = {})
      raise NotImplementedError
    end

    def attributes
      h = super
      h.merge((h['data'] || {}).stringify_keys)
    end

    def screenshot?
      false
    end

    def page_source?
      false
    end

    def same_step?(_other)
      false
    end

    private

    def validate_as_subclass
      return if self.class.to_s == type
      sub = becomes(type.constantize)
      sub.valid?
      sub.errors.each do |k, v|
        errors.add k, v
      end
    end
  end
end
