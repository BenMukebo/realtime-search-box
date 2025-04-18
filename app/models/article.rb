class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  scope :search_by_title, ->(query) { where('title ILIKE ?', "%#{query}%") if query.present? }
  scope :recent, -> { order(created_at: :desc) }

  def self.search_articles(query, user, ip_address)
    user ||= User.find_or_create_by_ip(ip_address)
    SearchArticle.create(query: query, user: user, ip_address: ip_address)
  end
end
