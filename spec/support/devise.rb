RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end

RSpec.shared_context 'with signed in user' do
  let(:current_user) { create :user }

  before do
    sign_in current_user, scope: :user
    expect(controller.current_user).not_to be_nil
  end

  after do
    sign_out :user
  end
end

RSpec.shared_context 'without signed in user' do
  let(:current_user) { create :user }

  before do
    sign_out :user
    expect(controller.current_user).to be_nil
  end
end

RSpec.shared_context 'with signed in admin user' do
  let(:current_admin_user) { create :admin_user }

  before do
    sign_in current_admin_user, scope: :admin_user
    expect(controller.current_admin_user).not_to be_nil
  end

  after do
    sign_out :admin_user
  end
end

RSpec.shared_context 'without signed in admin user' do
  let(:current_admin_user) { create :admin_user }

  before do
    sign_out :admin_user
    expect(controller.current_admin_user).to be_nil
  end
end
