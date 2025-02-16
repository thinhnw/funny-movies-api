class VideosController < ApplicationController
  def index
    render json: Video.ordered
  end

  def create
    video_data = FetchVideoService.new(current_user, video_params[:url]).call
    video = current_user.videos.create!(
      url: video_params[:url],
      title: video_data.dig("title"),
      description: video_data.dig("description"))
    render json: video, status: :created
  end
  private

  # Strong parameters
  def video_params
    params.require(:video).permit(:url)
  end
end
