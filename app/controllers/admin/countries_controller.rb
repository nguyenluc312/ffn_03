class Admin::CountriesController < ApplicationController
  load_and_authorize_resource

  def new
    @countries = Country.page(params[:page]).per Settings.per_page
    @country = Country.new
  end

  def create
    if @country.save
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to new_admin_country_url
  end

  private

  def country_params
    params.require(:country).permit :code
  end
end
