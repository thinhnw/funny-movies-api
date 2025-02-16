class Video < ApplicationRecord
  belongs_to :user
  validates :url, presence: true
  scope :ordered, -> { order(created_at: :desc) }
end
