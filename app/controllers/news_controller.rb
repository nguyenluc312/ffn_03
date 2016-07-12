class NewsController < ApplicationController
  before_action :load_news, only: :show

  def show
  end

  private
  def load_news
    @news = News.find_by id: params[:id]
    unless @news
      flash[:danger] = t ".invalid"
      redirect_to root_url
    end
  end
end
