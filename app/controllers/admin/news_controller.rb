class Admin::NewsController < ApplicationController
  before_action :load_news_types, only: :new

  def new
    @news = current_user.news.build
  end

  def create
    @news = News.new news_params
    if @news.save
      flash[:success] = t ".success"
      redirect_to admin_news_index_path
    else
      load_news_types
      render :new
    end
  end

  private
  def news_params
    params.require(:news).permit :title, :news_type_id, :brief_description,
      :content, :author, :user_id
  end

  def load_news_types
    @news_types = NewsType.all.map {|news_type| [news_type.name, news_type.id]}
  end
end
