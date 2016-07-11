class Admin::LeaguesController < ApplicationController
  before_action :load_league, only: :destroy

  def index
    @leagues = League.order created_at: :desc
  end

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

  def destroy
    if @league.league_seasons.any?
      flash[:danger] = t ".has_league_seasons"
    else
      if @league.destroy
        flash[:success] = t ".success"
      else
        flash[:danger] = t ".failed"
      end
    end
    redirect_to admin_leagues_url
  end

  private
  def league_params
    params.require(:league).permit :name, :country_id
  end

  def load_league
    @league = League.find_by id: params[:id]
    unless @league
      flash[:warning] = t ".warning"
      redirect_to admin_leagues_url
    end
  end
end
