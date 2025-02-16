class FetchVideoService
  def initialize(user, url)
    @user = user
    @url = url
    @youtube = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube.key = ENV["YOUTUBE_API_KEY"]
  end

  def call
    video_id = extract_youtube_video_id(@url)
    response = @youtube.list_videos("snippet", id: video_id)
    response.items.first.snippet
  end

  private
  def extract_youtube_video_id(url)
    regex = /^.*(youtu\.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
    match = url.match(regex)
    unless match
      raise ArgumentError, "Invalid YouTube URL" unless match
    else
      match[2]
    end
  end
end
