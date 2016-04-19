class TestStepSet < ApplicationRecord
  belongs_to :user, inverse_of: :test_step_sets
  belongs_to :base_test_step_set, class_name: 'TestStepSet', foreign_key: 'test_step_set_id', inverse_of: :inherited_test_step_sets
  has_many :inherited_test_step_sets, class_name: 'TestStepSet', foreign_key: 'test_step_set_id', inverse_of: :base_test_step_set
  has_many :test_steps, -> { order(position: :asc) }, class_name: 'TestStep::Base', inverse_of: :test_step_set

  validates :title, length: { maximum: 100 }, allow_blank: true
  validates :test_steps, length: { minimum: 1, maximum: 50 }

  scope :latest, -> { order(created_at: :desc) }

  acts_as_paranoid

  # FIXME: Remove the reader method and use nested attributes
  accepts_nested_attributes_for :test_steps, allow_destroy: true
  def test_steps_attributes
    test_steps.map(&:to_line).join("\n")
  end

  def assign_attributes(params = {})
    params = params.dup
    lines = params.delete(:test_steps_attributes)
    if lines.is_a?(String)
      existing_steps = test_steps.to_a
      lines = lines.split("\n").map(&:strip).compact
      params[:test_steps_attributes] = lines.map do |line|
        TestStep.from_line(line)
      end
      params[:test_steps_attributes] = params[:test_steps_attributes].compact.map.with_index do |ts, idx|
        matched = existing_steps.find { |mts| mts.same_step?(ts) }
        if matched
          existing_steps.delete(matched)
          ts = matched
        end
        h = ts.attributes.symbolize_keys
        h[:position] = idx + 1
        h.except(:created_at, :updated_at)
      end
      params[:test_steps_attributes] += existing_steps.map do |ts|
        ts.attributes.merge(_destroy: true).symbolize_keys.except(:position, :created_at, :updated_at)
      end
      params[:test_steps_attributes].each do |p|
        p.permit! if p.respond_to?(:permit!)
      end
    end
    super(params)
  end

  def same_test_step_set?(other)
    return false if other.nil?
    return false if self.class != other.class
    return false if test_steps_attributes != other.test_steps_attributes
    test_step_set_id == other.id || id == other.test_step_set_id || test_step_set_id == other.test_step_set_id
  end
end
