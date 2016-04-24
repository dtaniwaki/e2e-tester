class TestExecution < ApplicationRecord
  EXECUTION_SPAN = 1

  belongs_to :user, inverse_of: :test_executions
  belongs_to :test, inverse_of: :test_executions
  has_many :test_execution_browsers, inverse_of: :test_execution
  has_one :project, through: :test

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, ->(user) { where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user) }
  scope :with_test, ->(test) { where(test_id: test.is_a?(ActiveRecord::Base) ? test.id : test) }

  enum state: { initial: 0, running: 1, done: 2, failed: 3 }

  after_commit :send_notification!

  validate :validate_execution_limit

  def execute!(user, async: false)
    running!
    test.test_browsers.each do |tb|
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
    return unless test_execution_browsers.all? { |teb| teb.done? || teb.failed? }
    if test_execution_browsers.all?(&:done?)
      done!
    else
      failed!
    end
  end

  def send_notification!
    return if state_was == 'done'
    return if state != 'done'
    project.user_projects.includes(:user).find_each do |up|
      UserMailer.task_execution_result(up, self).deliver_now if up.user != user
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
end
