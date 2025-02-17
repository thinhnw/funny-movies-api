class NotificationChannel < ApplicationCable::Channel
  def subscribed
    reject if current_user.nil?
    stream_from "notification_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
