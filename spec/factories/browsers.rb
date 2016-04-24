FactoryGirl.define do
  factory :browser, class: Browser::Base do
    factory :local_browser, class: Browser::Local do
      sequence(:browser) { |n| "device-#{n}" }
    end
    factory :browserstack_browser, class: Browser::Browserstack do
      sequence(:device) { |n| "device-#{n}" }
      sequence(:browser) { |n| "browser-#{n}" }
      sequence(:browser_version) { |n| "browser_version-#{n}" }
      sequence(:os) { |n| "os-#{n}" }
      sequence(:os_version) { |n| "os_version-#{n}" }
    end
  end
end
