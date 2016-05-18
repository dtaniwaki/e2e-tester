RSpec.shared_context 'with authorized token' do
  let(:current_user) { create :user }
  let(:api_token) { create :user_api_token, user: current_user }

  before :example do
    sign_out :user
    request.headers['Authorization'] = "Bearer #{api_token.token}"
  end
end

RSpec.shared_context 'without authorized token' do
  let(:current_user) { create :user }

  before :example do
    sign_out :user
    request.headers['Authorization'] = ''
  end
end
