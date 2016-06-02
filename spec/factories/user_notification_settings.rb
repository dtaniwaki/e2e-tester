FactoryGirl.define do
  factory :user_notification_setting do
    user
    test
    user_integration { |us| create :slack_integration, user: us.user }
  end
end
