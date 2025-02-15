RSpec.describe 'Users::SessionsController', type: :request do
  describe 'POST /login' do
    it 'logs in a user' do
      user = create(:user)
      post '/login', params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_present
    end
  end

  describe 'DELETE /logout' do
    it 'logs out a user' do
      user = create(:user)
      post '/login', params: { user: { email: user.email, password: user.password } }
      auth_token = response.headers['Authorization']
      delete '/logout', headers: { 'Authorization' => auth_token }
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_blank
    end
  end
end
