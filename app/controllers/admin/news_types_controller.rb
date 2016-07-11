class Admin::NewsTypesController < ApplicationController

  def index
    @news_types = NewsType.all
  end

  def new
    @news_type = NewsType.new
  end

  def create
    @news_type = NewsType.new news_type_params
    if @news_type.save
      flash[:success] = t ".success"
      redirect_to admin_news_types_path
    else
      render :new
    end
  end

  private
  def news_type_params
    params.require(:news_type).permit :name
  end
end
