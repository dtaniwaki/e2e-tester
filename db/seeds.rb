unless User.where(email: 'foo@example.com').exists?
  User.create!(email: 'foo@example.com', password: '11111111', password_confirmation: '11111111', confirmed_at: DateTime.now)
end

Browser::Local.update_all!

unless BrowserSet.where(name: 'Local browsers').exists?
  BrowserSet.create!(name: 'Local browsers', browsers: Browser::Local.all)
end

if user = User.first
  project = user.projects.find_or_create_by!(title: 'Sample Project')
  test = project.tests.find_or_initialize_by(title: 'Sample Test')
  test.update_attributes!(user: user, browsers: Browser::Local.all, test_steps_attributes: 'None')
end
