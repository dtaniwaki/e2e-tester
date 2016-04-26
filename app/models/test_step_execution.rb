class TestStepExecution < ApplicationRecord
  belongs_to :test_step, class_name: 'TestStep::Base', inverse_of: :test_step_executions
  belongs_to :test_execution_browser, inverse_of: :test_step_executions
  has_one :screenshot, inverse_of: :test_step_execution
  has_one :page_source, inverse_of: :test_step_execution
  has_one :test_browser, through: :test_execution_browser
  has_one :browser, through: :test_execution_browser
  has_one :test_execution, through: :test_execution_browser

  scope :with_user, -> (user) { joins(:test_execution).merge(TestExecution.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }
  scope :with_test_execution, -> (te) { joins(:test_execution_browser).merge(TestExecutionBrowser.where(test_execution_id: te.is_a?(ActiveRecord::Base) ? te.id : te)) }
  scope :with_test_step, ->(test_step) { where(test_step_id: test_step.is_a?(ActiveRecord::Base) ? test_step.id : test_step) }
  scope :with_browser, ->(browser) { joins(:test_browser).merge(TestBrowser.where(browser_id: browser.is_a?(ActiveRecord::Base) ? browser.id : browser)) }

  enum state: { initial: 0, running: 1, done: 2, failed: 3 }

  validates :message, length: { maximum: 65_535 }, allow_blank: true

  def execute!(driver, variables = {})
    running!
    begin
      test_step.execute!(self, driver, variables)
      self.message = nil
      save!
      done!
    rescue => e
      logger.warn "Failed to execute TestStep##{id}: #{e.class} #{e.message}"
      # Errors thrown from web drivers vary
      if e.is_a? Selenium::WebDriver::Error::WebDriverError
        error = begin
                  JSON.parse(e.message.match(/^[^{]*({.*})[^}]*$/)[1])
                rescue
                  {}
                end
        self.message = error['errorMessage'] || e.message
      else
        self.message = e.message
      end
      save!
      failed!
    end
  end
end
