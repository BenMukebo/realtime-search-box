class SearchArticle < ApplicationRecord
  belongs_to :user

  validates :query, presence: true
end
