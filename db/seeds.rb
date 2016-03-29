unless User.where(email: 'foo@example.com').exists?
  User.create!(email: 'foo@example.com', password: '11111111', password_confirmation: '11111111', confirmed_at: DateTime.now)
end

Browser::Local.update_all!

unless BrowserSet.where(name: 'Local browsers').exists?
  BrowserSet.create!(name: 'Local browsers', browsers: Browser::Local.all)
end
