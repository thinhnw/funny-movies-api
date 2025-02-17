# spec/channels/connection_spec.rb
require 'rails_helper'

module ApplicationCable
  describe Connection, type: :channel do
    let(:user) { create(:user) }
    let(:valid_token) { JWT.encode({ sub: user.id }, ENV["DEVISE_JWT_SECRET_KEY"], 'HS256') }
    let(:invalid_token) { "invalid.token.string" }

    context "with a valid token" do
      it "successfully connects and sets current_user" do
        cookies[:token] = valid_token

        connect "/cable"

        expect(connection.current_user).to eq(user)
      end
    end

    context "with an invalid token" do
      it "rejects the connection" do
        cookies[:token] = invalid_token

        expect { connect "/cable" }.to have_rejected_connection
      end
    end

    context "with no token" do
      it "rejects the connection" do
        expect { connect "/cable" }.to have_rejected_connection
      end
    end
  end
end
