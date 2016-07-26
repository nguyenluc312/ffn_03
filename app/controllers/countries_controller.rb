class CountriesController < ApplicationController

  def index
    @search = Country.order(:name).search params[:q]
    @countries = @search.result.page(params[:page]) .per Settings.country.per_page
  end
end
