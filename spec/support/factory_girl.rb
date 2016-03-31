RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseRewinder.clean_all
    begin
      FactoryGirl.lint
    ensure
      DatabaseRewinder.clean_all
    end
  end
end
