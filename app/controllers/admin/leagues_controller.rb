class Admin::LeaguesController < Admin::BaseController
  load_and_authorize_resource

  before_action :load_countries, except: [:show, :destroy]

  def index
    @search = League.includes(:country, :league_seasons).search params[:q]
    @leagues = @search.result.order(created_at: :desc)
      .page(params[:page]).per Settings.leagues.per_page
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

  def edit
  end

  def update
    if @league.update_attributes league_params
      flash[:success] = t ".success"
      redirect_to admin_leagues_url
    else
      render :edit
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
