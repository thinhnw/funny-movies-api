require 'rails_helper'

RSpec.describe "Videos API", type: :request do
  # Create videos with explicit created_at timestamps

  describe "GET /videos" do
    let!(:video1) { create(:video, created_at: 3.days.ago) }
    let!(:video2) { create(:video, created_at: 2.days.ago) }
    let!(:video3) { create(:video, created_at: 1.days.ago) }

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

  describe "POST /videos" do
    let(:user) { create(:user) }
    let(:auth_token) { get_login_token(user) }

    context "with valid Youtube URL" do
      let(:valid_url) { "https://www.youtube.com/watch?v=example123" }
      let(:mock_service) { instance_double(Videos::YoutubeFetchService) }
      before do
        allow(Videos::YoutubeFetchService).to receive(:new).with(valid_url).and_return(mock_service)
        allow(mock_service).to receive(:call).and_return({ title: "Mocked Video Title", description: "Mocked Video Description" })
      end
      it "creates a new video from Youtube" do
        post videos_path,
            params: { video: { url: valid_url } },
            headers: { "Authorization" => auth_token }

        expect(response).to have_http_status(:created)
        expect(Video.count).to eq(1)

        video = Video.last
        expect(video.url).to eq(valid_url)
      end
    end

    context "with invalid Youtube URL" do
      let(:invalid_url) { "https://www.example.com/invalid" }
      it "returns an error response" do
        post videos_path,
            params: { video: { url: invalid_url } },
            headers: { "Authorization" => auth_token }

        expect(response).to have_http_status(:bad_request)
        expect(Video.count).to eq(0)
      end
    end

    context "when YoutubeService fails to fetch data" do
    end
  end
end
