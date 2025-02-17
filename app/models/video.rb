class Video < ApplicationRecord
  after_create_commit :broadcast_video_creation

  belongs_to :user
  validates :url, presence: true
  scope :ordered, -> { order(created_at: :desc) }

  def broadcast
    ActionCable.server.broadcast("notification_channel", self.to_json)
  end

  private

  def broadcast_video_creation
    BroadcastVideoJob.perform_async({
      id: id,
      url: url,
      title: title,
      user: user.email
  }.stringify_keys)
  end
end
