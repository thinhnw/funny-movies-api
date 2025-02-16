class VideosController < ApplicationController
  def index
    render json: Video.ordered
  end
end
