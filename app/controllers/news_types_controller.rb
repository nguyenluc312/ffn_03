class NewsTypesController < ApplicationController
  load_and_authorize_resource

  def show
    @news = @news_type.news.order(created_at: :desc)
      .page(params[:page]).per Settings.news.per_page_user
  end
end
