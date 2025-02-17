
require 'rails_helper'

RSpec.describe Videos::YoutubeFetchService, type: :service do
  let(:valid_url) { 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' }
  let(:invalid_url) { 'https://www.youtube.com/watch?v=invalid' }

  describe '#call' do
    let(:youtube_service) { instance_double(Google::Apis::YoutubeV3::YouTubeService) }
    let(:response) do
      instance_double(
        Google::Apis::YoutubeV3::ListVideosResponse,
        items: [
          instance_double(
            Google::Apis::YoutubeV3::Video,
            snippet: instance_double(
              Google::Apis::YoutubeV3::VideoSnippet,
              title: 'Video Title',
              description: 'Video Description')) ])
    end

    before do
      allow(Google::Apis::YoutubeV3::YouTubeService).to(
        receive(:new).and_return(youtube_service)
      )
      allow(youtube_service).to receive(:key=)
      allow(youtube_service).to receive(:list_videos).and_return(response)
    end

    context 'with a valid YouTube URL' do
      it 'fetches video data successfully' do
        service = Videos::YoutubeFetchService.new(valid_url)

        result = service.call

        expect(result).to eq({ title: 'Video Title', description: 'Video Description' })
      end
    end

    context 'with an invalid YouTube URL' do
      it 'raises an ArgumentError with "Invalid YouTube URL" message' do
        service = Videos::YoutubeFetchService.new(invalid_url)

        expect { service.call }.to raise_error(ArgumentError, 'Invalid YouTube URL')
      end
    end

    context 'when YouTube API does not return any video' do
      it 'raises an ArgumentError with "Cannot find Youtube video" message' do
        allow(youtube_service)
          .to receive(:list_videos)
          .and_return(
            instance_double(
              Google::Apis::YoutubeV3::ListVideosResponse,
              items: []
            )
          )
        service = Videos::YoutubeFetchService.new(valid_url)

        expect { service.call }.to raise_error(ArgumentError, 'Cannot find Youtube video')
      end
    end
  end

  describe '#extract_youtube_video_id' do
    context 'with a valid YouTube URL' do
      it 'returns the correct video ID' do
        service = Videos::YoutubeFetchService.new(valid_url)

        video_id = service.send(:extract_youtube_video_id, valid_url)

        expect(video_id).to eq('dQw4w9WgXcQ')
      end
    end

    context 'with an invalid YouTube URL' do
      it 'raises an ArgumentError with "Invalid YouTube URL" message' do
        service = Videos::YoutubeFetchService.new(invalid_url)

        expect { service.send(:extract_youtube_video_id, invalid_url) }.to(
          raise_error(ArgumentError, 'Invalid YouTube URL')
        )
      end
    end
  end
end
