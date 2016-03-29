class Test < ApplicationRecord
  belongs_to :project, inverse_of: :tests
  belongs_to :parent, class_name: 'Test', foreign_key: 'test_id', inverse_of: :children
  has_many :active_projects, class_name: 'Project', foreign_key: 'test_id', inverse_of: :current_test, dependent: :nullify
  has_many :user_tests, inverse_of: :test, dependent: :destroy
  has_many :test_executions, inverse_of: :test, dependent: :destroy
  has_many :test_steps, -> { order(position: :asc) }, class_name: 'TestStep::Base', inverse_of: :test, dependent: :destroy
  has_many :test_browsers, inverse_of: :test, dependent: :destroy
  has_many :browsers, through: :test_browsers
  has_many :children, class_name: 'Test', foreign_key: 'test_id', inverse_of: :parent, dependent: :destroy

  validates :test_browsers, length: { minimum: 1, maximum: 10 }
  validates :test_steps, length: { minimum: 1, maximum: 50 }

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
    test_steps_attributes == other.test_steps_attributes &&
      browser_ids == other.browser_ids
  end
end
