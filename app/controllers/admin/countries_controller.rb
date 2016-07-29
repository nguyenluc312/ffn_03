class Admin::CountriesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @search = Country.order(:name).search params[:q]
    @countries = @search.result.page(params[:page]) .per Settings.country.per_page
  end

  def new
  end

  def create
    if @country.save
      flash[:success] = t ".success"
        redirect_to admin_countries_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @country.update_attributes country_params
      flash[:success] = t ".success"
      redirect_to admin_countries_url
    else
      render :edit
    end
  end

  def destroy
    if @country.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to :back
  end

  private
  def country_params
    params.require(:country).permit :code, :flag
  end
end
