class RecordSearchJob < ApplicationJob
  queue_as :default

  def perform(query, user_id, ip_address)
    user = User.find_by(id: user_id) || User.find_or_create_by_ip(ip_address)
    last_search = SearchArticle.where(user_id: user.id).order(created_at: :desc).first

    if last_search && query.start_with?(last_search.query) && query.length > last_search.query.length
      # If User is typing forward (adding characters)
      last_search.update(query: query)
    elsif last_search.nil? || !last_search.query.start_with?(query)
      # New burst (not a deletion or prefix), create a new record
      SearchArticle.create(query: query, user: user, ip_address: ip_address)
    end
    # If the user is deleting (query is shorter or not an extension), do nothing
  end
end
