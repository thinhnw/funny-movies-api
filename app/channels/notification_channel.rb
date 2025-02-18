class NotificationChannel < ApplicationCable::Channel
  def subscribed
    @current_user = find_verified_user
    reject if @current_user.nil?
    stream_from "notification_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  protected
  def find_verified_user
    token = params[:token]
    reject unless token
    begin
      decoded_token = JWT.decode(
        token,
        ENV["DEVISE_JWT_SECRET_KEY"],
        true,
        { algorithm: "HS256" }
      )
      user_id = decoded_token.first["sub"]
      User.find(user_id)
    rescue
      logger.error "Error decoding token: #{e.message}"
      reject
    end
  end
end
