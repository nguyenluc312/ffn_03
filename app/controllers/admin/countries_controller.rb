class Admin::CountriesController < ApplicationController

  def new
    @countries = Country.page(params[:page]).per Settings.per_page
    @country = Country.new
  end

  def create
    @country = Country.new country_params
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
