class SearchArticle < ApplicationRecord
  belongs_to :user

  validates :query, presence: true

  scope :completed_searches_for_user, ->(user_id) {
    where(user_id: user_id).order(created_at: :desc).limit(10)
  }
end
