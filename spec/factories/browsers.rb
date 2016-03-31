FactoryGirl.define do
  factory :browser, class: Browser::Base do
    factory :local_browser, class: Browser::Local do
      browser 'foo'
    end
  end
end
