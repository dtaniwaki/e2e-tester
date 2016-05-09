module UserIntegration
  class Slack < Base
    include UrlHelper

    serialized_attribute :webhook_url

    validates :webhook_url, url: true, presence: true

    def test_execution_result(test_execution)
      # TODO: i18n
      text = "Hi #{user.name}! The test execution result of <#{test_version_position_url(test_execution.test_version)}|#{test_execution.test_version.title}> is ready."
      color = case test_execution.state
              when 'done'
                'good'
              when 'failed'
                'danger'
      end
      faraday.post(webhook_url, username: 'E2E Tester',
                                text: text,
                                attachments: [
                                  author_name: test_execution.user.name,
                                  title: "Test Execution \##{test_execution.to_param}",
                                  title_link: test_execution_url(test_execution),
                                  color: color
                                ])
    end

    private

    def faraday
      @faraday ||= Faraday.new(nil, ssl: { verify: false }) do |conn|
        conn.request :json
        conn.response :raise_error
        conn.adapter Faraday.default_adapter
        conn.options.timeout = 5
        conn.options.open_timeout = 3
      end
    end
  end
end
