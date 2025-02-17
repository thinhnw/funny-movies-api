module Videos
  class YoutubeFetchService < FetchService
    def initialize(url)
      super
      @youtube = Google::Apis::YoutubeV3::YouTubeService.new
      @youtube.key = ENV["YOUTUBE_API_KEY"]
    end

    def call
      video_id = extract_youtube_video_id(@url)
      response = @youtube.list_videos("snippet", id: video_id)
      if response.items.empty?
        raise ArgumentError, "Cannot find Youtube video"
      end
      format_output title: response.items.first.snippet.title,
                    description: response.items.first.snippet.description
    end

    private
    def extract_youtube_video_id(url)
      regex = /^.*(youtu\.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
      match = url.match(regex)
      unless match && match[2].size == 11
        raise ArgumentError, "Invalid YouTube URL"
      else
        match[2]
      end
    end
  end
end
