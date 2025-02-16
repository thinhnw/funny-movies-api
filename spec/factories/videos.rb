FactoryBot.define do
  factory :video do
    url { "https://youtu.be/example" }
    user { create(:user) }
    title { "Example Video" }
    description { "This is an example video" }
  end
end
