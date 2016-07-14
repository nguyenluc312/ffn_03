class Admin::NewsTypesController < ApplicationController
  load_and_authorize_resource

  def index
    @news_types = NewsType.all
  end

  def new
  end

  def create
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
