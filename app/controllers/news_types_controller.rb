class NewsTypesController < ApplicationController
  load_and_authorize_resource

  def show
    @search =  @news_type.news.search params[:q]
    @news = @search.result.order(created_at: :desc)
      .page(params[:page]).per Settings.news.per_page_user
    @hot_news = News.hot_news
  end
end
