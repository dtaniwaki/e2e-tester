unless User.first
  User.create!(name: 'Foo', email: 'foo@example.com', password: '11111111', password_confirmation: '11111111', confirmed_at: DateTime.now)
end

Browser::Local.update_all!

unless BrowserSet.where(name: 'Local browsers').exists?
  BrowserSet.create!(name: 'Local browsers', browsers: Browser::Local.all)
end

if user = User.first
  test = user.tests.first_or_create!
  test_version = test.test_versions.find_or_initialize_by(title: 'Sample Test')
  if test_version.new_record?
    test_version.update_attributes!(user: user, browsers: Browser::Local.all, test_steps: [TestStep::None.new])
  end
  test_step_set = SharedTestStepSet.find_or_initialize_by(title: 'Sample Test Step Set')
  if test_step_set.new_record?
    test_step_set.update_attributes!(user: user, test_steps: [TestStep::None.new])
  end
end

unless AdminUser.first
  AdminUser.create!(name: 'Foo', email: 'foo@example.com', password: '11111111', password_confirmation: '11111111')
end
