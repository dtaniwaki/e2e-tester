module TestStep
  class PageSource < Base
    has_many :page_sources, inverse_of: :test_step, class_name: '::PageSource', foreign_key: 'test_step_id'

    def execute!(test_step_execution, driver, _variables = {})
      page_sources.find_or_create_by(test_step_execution_id: test_step_execution.id).update_attributes!(source: StringIO.new(driver.page_source))
    end

    def to_line
      'Store page source'
    end

    def page_source?
      true
    end

    def same_step?(other)
      self.class == other.class
    end
  end
end
