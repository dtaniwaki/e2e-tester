FactoryGirl.define do
  factory :project do
    user
    title 'foo'
    after :create do |p|
      p.tests = create_list :test, 1, project: p
    end
  end
end
