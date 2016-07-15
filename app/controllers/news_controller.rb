class NewsController < ApplicationController
  before_action :load_news, only: :show

  def show
    @comments = @news.comments.order created_at: :desc
    @comment = Comment.new
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
