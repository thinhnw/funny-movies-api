require 'rails_helper'

RSpec.describe 'Users::RegistrationsController', type: :request do
  describe 'POST /signup' do
    it 'registers a new user' do
      post '/signup', params: { user: { email: 'new_user@example.com', password: 'password123' } }
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_present
    end
  end
end
