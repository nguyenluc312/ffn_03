class StaticPagesController < ApplicationController
  def home
    @news = News.order(created_at: :desc).limit Settings.news.preview_newest
    @preview_news_types = NewsType.preview_news_in_types
    @hot_news = News.hot_news
  end

  def help
  end

  def contact
  end
end
