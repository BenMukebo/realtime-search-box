class ArticlesController < ApplicationController
  def index
    @search = query_params[:query]

    if @search.present?
      @articles = Article.search_by_title(@search).recent.limit(10)
      record_search(@search)
    else
      @articles = Article.recent.limit(10)
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("articles", partial: "articles", locals: { articles: @articles }) }
    end
  end

  private

  def record_search(query)
    Article.search_articles(query, current_user, request.remote_ip) if request.format.html?
  end

  def current_user
    @current_user ||= User.find_or_create_by_ip(request.remote_ip)
  end

  def query_params
    params.permit(:search, :query, :page, :per_page)
  end
end
