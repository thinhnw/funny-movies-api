# spec/channels/notification_channel_spec.rb
require 'rails_helper'

RSpec.describe NotificationChannel, type: :channel do
  let(:user) { create(:user) }

  context "when a user is authenticated" do
    before do
      stub_connection(current_user: user)
    end

    it "subscribes to the channel" do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("notification_channel")
    end
  end

  context "when there is no authenticated user" do
    before do
      stub_connection(current_user: nil)
    end

    it "rejects the subscription" do
      subscribe
      expect(subscription).to be_rejected
    end
  end
end
