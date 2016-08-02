class NewsController < ApplicationController
  load_and_authorize_resource only: :show

  def index
    @search = News.search params[:news_search], search_key: :news_search
    @news = @search.result.page(params[:page]).per Settings.news.per_page_user
    @hot_news = News.hot_news
  end

  def show
    @comments = @news.comments.includes(:user).order created_at: :desc
    @comment = Comment.new
    @hot_news = News.hot_news
  end
end
