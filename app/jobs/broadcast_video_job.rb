class BroadcastVideoJob
  include Sidekiq::Job

  def perform(video)
    ActionCable.server.broadcast("notification_channel", JSON.parse(video))
  end
end
