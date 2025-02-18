require "rails_helper"

RSpec.describe NotificationChannel, type: :channel do
  let(:user) { create(:user) }
  let(:valid_token) { JWT.encode({ sub: user.id }, ENV["DEVISE_JWT_SECRET_KEY"], "HS256") }
  let(:invalid_token) { JWT.encode({ sub: 9999 }, "wrong_secret_key", "HS256") }

  context "with a valid token" do
    it "successfully subscribes" do
      subscribe token: valid_token

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("notification_channel")
    end
  end

  context "with an invalid token" do
    it "rejects the subscription" do
      subscribe token: invalid_token

      expect(subscription).to be_rejected
    end
  end

  context "with no token" do
    it "rejects the subscription" do
      subscribe token: nil

      expect(subscription).to be_rejected
    end
  end
end
