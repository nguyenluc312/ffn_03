class NewsController < ApplicationController
  load_and_authorize_resource only: :show

  def index
    @news = News.order(created_at: :desc).limit Settings.news.preview_newest
    @preview_news_types = NewsType.preview_news_in_types
  end

  def show
    @comments = @news.comments.order created_at: :desc
    @comment = Comment.new
  end
end
