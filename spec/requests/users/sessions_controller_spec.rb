RSpec.describe 'Users::SessionsController', type: :request do
  describe 'POST /login' do
    let(:user) { create(:user) }
    it 'logs in a user' do
      post '/login', params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_present
    end
  end

  describe 'DELETE /logout' do
    let(:user) { create(:user) }
    let(:auth_token) { get_login_token(user) }
    it 'logs out a user' do
      delete '/logout', headers: { 'Authorization' => auth_token }
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_blank
    end
  end
end
