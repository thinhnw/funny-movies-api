require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET /me" do
    let(:user) { create(:user) }
    let(:auth_token) { get_login_token(user) }

    it "returns the current user as JSON" do
      get me_users_path, headers: { "Authorization" => auth_token }

      expect(response).to have_http_status(:ok)

      res = JSON.parse(response.body)

      expect(res["id"]).to eq(user.id)
      expect(res["email"]).to eq(user.email)
    end
  end
end
