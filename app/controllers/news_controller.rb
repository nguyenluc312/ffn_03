class NewsController < ApplicationController
  load_and_authorize_resource only: :show

  def index
    @news = News.order(created_at: :desc).limit Settings.news.preview_newest
    @preview_news_types = NewsType.preview_news_in_types
    @hot_news = News.hot_news
  end

  def show
    @comments = @news.comments.includes(:user).order created_at: :desc
    @comment = Comment.new
    @hot_news = News.hot_news
  end
end
