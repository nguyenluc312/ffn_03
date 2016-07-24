class Admin::NewsTypesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @news_types = NewsType.order(updated_at: :desc).includes :news
  end

  def new
  end

  def create
    if @news_type.save
      respond_to do |format|
        format.html {redirect_to admin_news_types_path}
        format.js
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @news_type.update_attributes news_type_params
      respond_to do |format|
        format.html {redirect_to admin_news_types_path}
        format.js
      end
    else
      render :edit
    end
  end

  def destroy
    if @news_type.destroy
      respond_to do |format|
        format.html {redirect_to admin_news_types_path}
        format.js
      end
    end
  end

  private
  def news_type_params
    params.require(:news_type).permit :name
  end
end
