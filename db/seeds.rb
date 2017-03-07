unless User.first
  user = User.create!(username: 'foo', name: 'Foo', email: 'foo@example.com', password: '11111111', password_confirmation: '11111111', confirmed_at: DateTime.now)
  user.user_api_tokens.create!(name: 'abcd', token: 'abcd')
end

Browser::Local.update_all!

unless BrowserSet.where(name: 'Local browsers').exists?
  BrowserSet.create!(name: 'Local browsers', browsers: Browser::Local.all)
end

if user = User.first
  test = user.tests.first_or_create!
  test_version = test.test_versions.find_or_initialize_by(title: 'Sample Test v1')
  if test_version.new_record?
    test_version.update_attributes!(user: user, browsers: [Browser::Local.find_by_browser('phantomjs')], test_steps: [TestStep::None.new])
    test_execution = test_version.test_executions.with_user(user).first_or_create!.execute!(user)
  end
  test_version = test.test_versions.find_or_initialize_by(title: 'Sample Test v2')
  if test_version.new_record?
    test_version.update_attributes!(user: user, browsers: [Browser::Local.find_by_browser('phantomjs')], test_steps: [TestStep::None.new])
    test_execution = test_version.test_executions.with_user(user).first_or_create!.execute!(user)
  end
  test_step_set = SharedTestStepSet.find_or_initialize_by(title: 'Sample Test Step Set')
  if test_step_set.new_record?
    test_step_set.update_attributes!(user: user, test_steps: [TestStep::None.new])
  end
end
