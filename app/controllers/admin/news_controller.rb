class Admin::NewsController < ApplicationController
  before_action :load_news_types, only: [:new, :edit, :index]

  load_and_authorize_resource

  def index
    @q = News.order(created_at: :desc).search params[:q]
    @news = @q.result
      .page(params[:page]).per Settings.news.per_page
  end

  def new
    @news = current_user.news.build
  end

  def create
    if @news.save
      flash[:success] = t ".success"
      redirect_to admin_news_index_path
    else
      load_news_types
      render :new
    end
  end

  def edit
  end

  def update
    if @news.update_attributes news_params
      flash[:success] = t ".success"
      redirect_to admin_news_index_path
    else
      load_news_types
      render :edit
    end
  end

  def destroy
    if @news.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to :back
  end

  private
  def news_params
    params.require(:news).permit :title, :news_type_id, :brief_description,
      :represent_image, :content, :author, :user_id
  end

  def load_news_types
    @news_types = NewsType.all.map {|news_type| [news_type.name, news_type.id]}
  end
end
