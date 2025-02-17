require 'rails_helper'

RSpec.describe 'Users::RegistrationsController', type: :request do
  describe 'POST /signup' do
    it 'registers a new user' do
      post '/signup', params: { user: { email: 'new_user@example.com', password: 'password123' } }
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_present
    end
  end

  describe 'DELETE /signup' do
    let(:user) { create(:user) }
    let(:auth_token) { get_login_token(user) }
    it 'returns not found' do
      delete '/signup', headers: { 'Authorization' => auth_token }
      expect(response).to have_http_status(:not_found)
    end
  end
end
