class Test < ApplicationRecord
  belongs_to :user, inverse_of: :tests
  belongs_to :project, inverse_of: :tests
  belongs_to :base_test, class_name: 'Test', foreign_key: 'test_id', inverse_of: :inherited_tests
  has_many :user_tests, inverse_of: :test, dependent: :destroy
  has_many :test_executions, inverse_of: :test, dependent: :destroy
  has_many :test_steps, -> { order(position: :asc) }, class_name: 'TestStep::Base', inverse_of: :test, dependent: :destroy
  has_many :test_browsers, inverse_of: :test, dependent: :destroy
  has_many :browsers, through: :test_browsers
  has_many :inherited_tests, class_name: 'Test', foreign_key: 'test_id', inverse_of: :base_test, dependent: :destroy

  validates :test_browsers, length: { minimum: 1, maximum: 10 }
  validates :test_steps, length: { minimum: 1, maximum: 50 }
  validate :validate_same_test

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, ->(user) { joins(:user_tests).merge(UserTest.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }

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

  def same_test?(other)
    return false if other.nil?
    test_steps_attributes == other.test_steps_attributes &&
      browser_ids == other.browser_ids &&
      (test_id == other.id || id == other.test_id || test_id == other.test_id)
  end

  private

  def validate_same_test
    errors.add :base, 'The test is the same as the base test' if base_test && same_test?(base_test)
  end
end
