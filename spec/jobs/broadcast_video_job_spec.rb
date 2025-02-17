require 'rails_helper'


RSpec.describe BroadcastVideoJob, type: :job do
  let(:video) { create(:video) }

  it "broadcasts video to the notification channel" do
    Sidekiq::Testing.inline!
    allow(ActionCable.server).to receive(:broadcast)

    payload = video.to_json
    BroadcastVideoJob.perform_async(payload)

    expect(ActionCable.server)
      .to have_received(:broadcast).with("notification_channel", JSON.parse(payload))
  end
end
