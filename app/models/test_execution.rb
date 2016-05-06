class TestExecution < ApplicationRecord
  EXECUTION_SPAN = 1

  belongs_to :user, inverse_of: :test_executions
  belongs_to :test_version, inverse_of: :test_executions
  has_many :test_execution_browsers, inverse_of: :test_execution
  has_one :test, through: :test_version

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, ->(user) { where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user) }
  scope :with_test_version, ->(test_version) { where(test_version_id: test_version.is_a?(ActiveRecord::Base) ? test_version.id : test_version) }

  enum state: { initial: 0, running: 1, done: 2, failed: 3 }

  after_commit :send_notification!

  validate :validate_execution_limit
  validate :validate_executable

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
    return if previous_changes[:state].nil?
    return unless done? || failed?
    (test.user_tests.preload(:user).map(&:user) + [user]).uniq.each do |u|
      UserMailer.test_execution_result(u, self).deliver_now
    end
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
