class TestExecutionBrowser < ApplicationRecord
  belongs_to :test_execution, inverse_of: :test_execution_browsers
  belongs_to :test_browser, inverse_of: :test_execution_browsers
  has_one :browser, through: :test_browser
  has_one :test_version, through: :test_execution
  has_many :test_step_executions, inverse_of: :test_execution_browser

  enum state: { initial: 0, running: 1, done: 2, failed: 3 }

  def execute!(user)
    running!
    initialize_test_step_executions!
    # Do not receive variables as the argument because it's vulnerable to execute it via Sidekiq
    variables = user.variables(test_version)
    credential = user.user_credentials.find { |c| c.credential_for?(browser) }
    driver = browser.driver(credential)
    test_step_executions.each do |tse|
      tse.execute!(driver, variables)
    end
    check_completion!
  rescue => e
    self.error = e.message
    logger.warn "#{e.message}\n  #{e.backtrace.join("\n  ")}"
    save!
    failed!
  ensure
    test_execution.check_completion!
    driver&.quit
  end

  def execute_async!(user)
    # TODO: Should perform after commit
    TestExecutionJob.perform_in(1.second, user.id, id)
  end

  def check_completion!
    if test_step_executions.all?(&:done?)
      done!
    else
      failed!
    end
  end

  def initialize_test_step_executions!
    test_version.test_steps.each do |ts|
      test_step_executions.eager_load(:test_step).find_or_create_by(test_step_id: ts.id)
    end
  end
end
