class TestStepSet < ApplicationRecord
  belongs_to :user, inverse_of: :test_step_sets
  belongs_to :base_test_step_set, class_name: 'TestStepSet', foreign_key: 'test_step_set_id', inverse_of: :inherited_test_step_sets
  has_many :inherited_test_step_sets, class_name: 'TestStepSet', foreign_key: 'test_step_set_id', inverse_of: :base_test_step_set
  has_many :test_steps, -> { order(position: :asc) }, class_name: 'TestStep::Base', inverse_of: :test_step_set
  has_many :test_step_sets, class_name: 'TestStep::StepSet', inverse_of: :shared_test_step_set
  has_many :shared_test_step_sets, through: :test_step_sets, source: :shared_test_step_set

  validates :title, length: { minimum: 1, maximum: 100 }, uniqueness: { scope: [:type, :project_id] }, allow_nil: true
  validates :description, length: { maximum: 65_535 }, allow_blank: true
  validates :test_steps, length: { minimum: 1, maximum: 50 }, allow_blank: true

  scope :latest, -> { order(created_at: :desc) }

  acts_as_paranoid

  accepts_nested_attributes_for :test_steps, allow_destroy: true

  def same_test_step_set?(other)
    return false if other.nil?
    return false if self.class != other.class
    return false if test_steps.length != other.test_steps.length
    return false if test_steps.map { |ts| ts.becomes ts.type.constantize }.zip(other.test_steps.map { |ts| ts.becomes ts.type.constantize }).any? { |a, b| !a.same_step?(b) }
    return false if title != other.title
    return false if description != other.description
    test_step_set_id == other.id || id == other.test_step_set_id || test_step_set_id == other.test_step_set_id
  end
end
