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

  private
  def country_params
    params.require(:country).permit :code, :flag
  end
end
