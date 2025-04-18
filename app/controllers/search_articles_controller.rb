class SearchArticlesController < ApplicationController
  def index
    @user = current_user

    if @user
      @user_searches = SearchArticle.get_completed_searches(@user.id)
    end
  end

  private

  def current_user
    @current_user ||= User.find_or_create_by_ip(request.remote_ip)
  end
end
