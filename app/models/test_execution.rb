class TestExecution < ApplicationRecord
  EXECUTION_SPAN = 1

  belongs_to :user, inverse_of: :test_executions
  belongs_to :test_version, inverse_of: :test_executions
  has_many :test_execution_browsers, inverse_of: :test_execution
  has_one :test, through: :test_version
  has_many :test_execution_shares, inverse_of: :test_execution

  scope :with_user, ->(user) { where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user) }
  scope :with_test_version, ->(test_version) { where(test_version_id: test_version.is_a?(ActiveRecord::Base) ? test_version.id : test_version) }

  enum state: { initial: 0, running: 1, done: 2, failed: 3 }

  after_commit :send_notification_async!, if: -> { previous_changes[:state].present? && (done? || failed?) }

  validate :validate_execution_limit
  validate :validate_executable

  attr_accessor :token
  alias_attribute :executed_at, :created_at
  alias_attribute :executed_by, :user

  def execute!(user, async: false)
    running!
    test_version.test_browsers.each do |tb|
      test_execution_browsers.find_or_create_by(test_browser_id: tb.id)
    end
    test_execution_browsers.each do |teb|
      if async
        teb.execute_async!(user)
      else
        teb.execute!(user)
      end
    end
  end

  def execute_async!(user)
    execute!(user, async: true)
  end

  def check_completion!
    return if test_execution_browsers.any? { |teb| teb.initial? || teb.running? }
    if test_execution_browsers.all?(&:done?)
      done!
    else
      failed!
    end
  end

  def send_notification!
    executer_test = nil
    test.user_tests.preload(user: :user_integrations).find_each do |ut|
      if ut.user == user
        executer_test = ut
        next
      end
      [ut.user, *ut.user.user_integrations].each do |ui|
        ui.notify!(:test_execution_result, self) if %w(all_tests).any? { |value| ui.notify?(:test_execution_result, ut) == value }
      end
    end
    u = executer_test&.user || user
    [u, *u.user_integrations].each do |ui|
      ui.notify!(:test_execution_result, self) if %w(all_tests only_self).any? { |value| ui.notify?(:test_execution_result, executer_test) == value }
    end
  end

  def with_authorized_token?
    !!token && test_execution_shares.available.exists?(token: token)
  end

  private

  def validate_execution_limit
    limit_time = EXECUTION_SPAN.minutes.ago
    last_execution = user.test_executions.last
    if last_execution && last_execution != self && new_record? && last_execution.created_at > limit_time
      diff = ((user.test_executions.last.created_at - limit_time) / 60).ceil
      errors.add :base, "You can execute only one test every #{EXECUTION_SPAN} minutes (#{diff} minutes)"
    end
  end

  def validate_executable
    return if test_version.executable?
    errors.add :base, 'The test is not executable'
  end
end
