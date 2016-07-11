class Admin::LeaguesController < ApplicationController

  def new
    @countries = Country.all.map {|country| [country.name, country.id]}
    @league = League.new
  end

  def create
    @league = League.new league_params
    if @league.save
      flash[:success] = t ".success"
      redirect_to admin_leagues_url
    else
      render :new
    end
  end

  private
  def league_params
    params.require(:league).permit :name, :country_id
  end
end
