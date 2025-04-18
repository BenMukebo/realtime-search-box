# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

articles = [
  { title: 'The Future of AI', content: 'Artificial Intelligence is rapidly evolving...' },
  { title: 'SpaceX and Mars', content: 'Elon Musk plans to colonize Mars within the next decade...' },
  { title: 'React vs Vue', content: 'Both frameworks are great, but React has broader adoption...' },
  { title: 'Ruby on Rails in 2025', content: 'Rails continues to thrive with Hotwire and performance updates...' },
  { title: 'The Rise of Tailwind CSS', content: 'Utility-first CSS is becoming a standard for frontend design...' },
  { title: 'Quantum Computing Explained', content: 'Quantum bits operate differently from classical bits...' },
  { title: 'The Mystery of Black Holes', content: 'Black holes are regions in space where gravity is so strong...' },
  { title: 'Kigali’s Tech Scene', content: 'Rwanda is becoming a regional hub for innovation and tech...' },
  { title: 'How to Learn Programming Fast', content: 'Focus on projects, consistency, and real-world problems...' },
  { title: 'Understanding APIs', content: 'APIs allow different systems to talk to each other...' },
  { title: 'The Benefits of Meditation', content: 'Meditation can reduce stress and improve focus...' },
  { title: 'The Impact of Climate Change', content: 'Climate change is affecting weather patterns globally...' },
  { title: 'The Evolution of Web Development', content: 'Web development has come a long way since the 90s...' },
  { title: 'The Importance of Cybersecurity',
    content: 'With the rise of digital threats, cybersecurity is crucial...' },
  { title: 'The Future of Renewable Energy', content: 'Renewable energy sources are becoming more viable...' },
  { title: 'The Psychology of Color', content: 'Colors can influence mood and behavior...' }
]

if Rails.env.development? || Rails.env.test?
  # Create users
  # 3.times do |i|
  #   User.create(user_name: "User#{i}", ip_address: "192.168.1.#{i + 1}")
  # end

  # Create articles
  Article.destroy_all
  articles.each do |article|
    Article.create(title: article[:title], content: article[:content])
  end
end
