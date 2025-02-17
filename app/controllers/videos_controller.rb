class VideosController < ApplicationController
  before_action :authenticate_user!, only: [ :create ]
  def index
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : 2

    videos = Video.ordered.includes(:user).offset((page - 1) * limit).limit(limit)

    render json: {
      videos: videos.map do |video|
        video.as_json(only: [ :id, :url, :title, :description, :created_at ]).merge(
          user: { email: video.user.email }
        )
      end,
      current_page: page,
      limit: limit,
      total_videos: Video.count
    }, status: :ok
  end

  def create
    begin
      service = Videos::FetchServiceFactory.create(video_params[:url])
      video_data = service.call
      video = current_user.videos.create!(
        url: video_params[:url],
        title: video_data[:title],
        description: video_data[:description])
      render json: video, status: :created
    rescue => e
      logger.error("Video creation failed: #{e.message}, #{e.backtrace.join("\n")}")
      render json: { error: { message: "An error occurred while processing your request. Please try again later." } }, status: :bad_request
    end
  end
  private

  # Strong parameters
  def video_params
    params.require(:video).permit(:url)
  end
end
