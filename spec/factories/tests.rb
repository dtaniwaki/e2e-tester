FactoryGirl.define do
  factory :test do
    user
    after :build do |t|
      t.updating_test_versions << build(:test_version, test: t)
    end
  end
end
