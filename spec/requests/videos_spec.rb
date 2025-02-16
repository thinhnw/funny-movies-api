require 'rails_helper'

RSpec.describe "Videos API", type: :request do
  # Create videos with explicit created_at timestamps
  let!(:video1) { create(:video, created_at: 3.days.ago) }
  let!(:video2) { create(:video, created_at: 2.days.ago) }
  let!(:video3) { create(:video, created_at: 1.days.ago) }

  describe "GET /videos" do
    it "returns a list of videos sorted by created_at in descending order" do
      # Make the GET request to the API endpoint
      get videos_path

      # Check the response status
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      videos = JSON.parse(response.body)

      # Verify the order of videos
      expect(videos.size).to eq(3)
      expect(videos[0]["id"]).to eq(video3.id) # Most recent video first
      expect(videos[1]["id"]).to eq(video2.id)
      expect(videos[2]["id"]).to eq(video1.id) # Oldest video last
    end
  end
end
