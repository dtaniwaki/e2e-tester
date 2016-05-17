module UserIntegration
  class Slack < Base
    include UrlHelper
    include I18nHelper

    serialized_attribute :webhook_url

    validates :webhook_url, url: true, presence: true
    validates_with SimilarRecordValidator, count: 10, conditions: [:user_id]

    def test_execution_result(test_execution)
      title = I18n.t('misc.integration.slack.title', execution_id: test_execution.to_param)
      text = I18n.t('misc.integration.slack.body', name: user.name, url: test_version_position_url(test_execution.test_version), title: test_execution.test_version.title)

      color = case test_execution.state
              when 'done'
                'good'
              when 'failed'
                'danger'
      end
      faraday.post(webhook_url, username: Settings.application.site_name,
                                text: text,
                                attachments: [
                                  author_name: test_execution.user.name,
                                  title: title,
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
