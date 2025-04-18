class SearchArticlesController < ApplicationController
  def index
    @user = current_user
    if @user
      @user_searches = SearchArticle.completed_searches_for_user(@user.id)
    end
  end

  def record
    query = params[:query]
    user = current_user
    RecordSearchJob.perform_later(query, user.id, request.remote_ip) if query.present?
    head :ok
  end
end
