class VideosController < ApplicationController
  before_action :authenticate_user!, only: [ :create ]
  def index
    render json: Video.ordered
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
    rescue ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    end
  end
  private

  # Strong parameters
  def video_params
    params.require(:video).permit(:url)
  end
end
