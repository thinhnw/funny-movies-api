class Video < ApplicationRecord
  after_create_commit :broadcast_video_creation

  belongs_to :user
  validates :url, presence: true
  scope :ordered, -> { order(created_at: :desc) }

  private

  def broadcast_video_creation
    payload = self.to_json(include: { user: { only: :email } })
    BroadcastVideoJob.perform_async(payload)
  end
end
