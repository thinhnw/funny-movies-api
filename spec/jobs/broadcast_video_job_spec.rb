require 'rails_helper'


RSpec.describe BroadcastVideoJob, type: :job do
  let(:video) { create(:video) }

  it "broadcasts video to the notification channel" do
    Sidekiq::Testing.inline!
    allow(ActionCable.server).to receive(:broadcast)

    BroadcastVideoJob.perform_async(video.to_json)

    expect(ActionCable.server)
      .to have_received(:broadcast).with("notification_channel", video.to_json)
  end
end
