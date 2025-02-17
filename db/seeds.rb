# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  alice = User.find_or_create_by!(email: "alice@foo.bar") do |user|
    user.password = "password"
  end

  bob = User.find_or_create_by!(email: "bob@foo.bar") do |user|
    user.password = "password"
  end

  alice.videos.create!(
    url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    title: "Rick Astley - Never Gonna Give You Up (Official Music Video)",
    description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Accusamus hic perferendis iste suscipit delectus facilis quibusdam dolores similique provident magnam."
  )
  bob.videos.create!(
    url: "https://www.youtube.com/watch?v=aAkMkVFwAoo",
    title: "Mariah Carey - All I Want for Christmas Is You (Make My Wish Come True Edition)",
    description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Accusamus hic perferendis iste suscipit delectus facilis quibusdam dolores similique provident magnam."
  )
end
