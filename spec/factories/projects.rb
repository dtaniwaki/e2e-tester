FactoryGirl.define do
  factory :project do
    user
    title 'foo'
    after :build do |p|
      p.current_test ||= build(:test, project: p)
    end
  end
end
