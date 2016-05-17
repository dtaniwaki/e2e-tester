module TestStep
  class Navigation < Base
    using Refinements::ReplaceVariables

    validates :url, length: { minimum: 1, maximum: 255 }, presence: true
    validates :url, url: true, unless: -> (ts) { ts.url =~ /{[^}]+}/ }

    serialized_attribute :url

    def execute!(_test_step_execution, driver, variables = {})
      url = self.url.replace_variables(variables)
      driver.navigate.to(url)
    end

    def to_line
      "Navigate to #{url}"
    end

    def same_step?(other)
      self.class == other.class && url == other.url
    end
  end
end
