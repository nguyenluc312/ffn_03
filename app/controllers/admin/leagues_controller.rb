class Admin::LeaguesController < Admin::BaseController
  load_and_authorize_resource

  before_action :load_countries, only: [:new, :create]

  def index
    @leagues = League.order(created_at: :desc).includes(:country)
      .group_by{|league| league.country}
  end

  def new
  end

  def create
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

  def load_countries
    @countries = Country.pluck :name, :id
  end

  def league_params
    params.require(:league).permit :name, :country_id, :founded_at, :introduction
  end
end
