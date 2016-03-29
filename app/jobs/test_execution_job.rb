class TestExecutionJob
  include Sidekiq::Worker

  sidekiq_options queue: :test_execution, retry: false, backtrace: true, unique: :while_executing

  def perform(user_id, execution_id)
    user = User.find(user_id)
    execution_browser = user.test_execution_browsers.find(execution_id)
    execution_browser.execute!(user)
  end
end
