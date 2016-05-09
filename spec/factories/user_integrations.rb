FactoryGirl.define do
  factory :slack_integration, class: UserIntegration::Slack do
    user
    name 'foo'
    webhook_url 'http://localhost/'
  end
end
