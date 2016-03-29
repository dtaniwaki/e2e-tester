RSpec.configure do |config|
  config.before(:suite) do
    DatabaseRewinder.clean_all
    begin
      FactoryGirl.lint
    ensure
      DatabaseRewinder.clean_all
    end
  end
end
