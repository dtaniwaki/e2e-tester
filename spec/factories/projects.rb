FactoryGirl.define do
  factory :project do
    user
    title 'foo'
    after :create do |p|
      p.tests = create_list :test, 1, project: p
      p.current_test = p.tests.last
    end
  end
end
