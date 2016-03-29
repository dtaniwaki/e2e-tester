module TestStep
  class Navigation < Base
    using Refinements::ReplaceVariables

    validates :url, length: { minimum: 1, maximum: 255 }, url: true, presence: true

    serialized_attribute :url

    def execute!(_test_step_execution, driver, variables = {})
      url = self.url.replace_variables(variables)
      driver.navigate.to(url)
    end

    # FIXME: temporary implementation
    def to_line
      "Navigate to #{url}"
    end

    # FIXME: temporary implementation
    def self.from_line(line)
      new(url: Regexp.last_match(1)) if line =~ line_regexp
    end

    def self.line_regexp
      /^navigate to ([^ ]*)/i
    end

    def same_step?(other)
      self.class == other.class && url == other.url
    end
  end
end
