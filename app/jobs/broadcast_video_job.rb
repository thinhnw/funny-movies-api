class BroadcastVideoJob
  include Sidekiq::Job

  def perform(video)
    ActionCable.server.broadcast("notification_channel", video)
  end
end
