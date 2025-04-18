class SearchArticle < ApplicationRecord
  belongs_to :user

  validates :query, presence: true

  # Get completed searches without duplicating intermediate searches
  def self.get_completed_searches(user_id)
    searches = where(user_id: user_id).order(created_at: :asc)
    completed_searches = []

    searches.each_with_index do |search, index|
      next_search = searches[index + 1]

      # If this is the last search or the next search doesn't start with this one
      if next_search.nil? || !next_search.query.start_with?(search.query)
        completed_searches << search
      end
    end

    completed_searches
  end

  # Get trending searches across all users
  # def self.trending_searches(limit = 10)
  #   grouped_by_query.limit(limit)
  # end
end
