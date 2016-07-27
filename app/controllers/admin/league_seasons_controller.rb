class Admin::LeagueSeasonsController < Admin::BaseController
  load_and_authorize_resource :league, except: [:index, :destroy, :show]
  load_and_authorize_resource through: :league, except: [:index, :destroy, :show]
  load_and_authorize_resource only: :index
  before_action :load_years, :load_teams, except: [:index, :destroy, :show]

  def index
    @search = LeagueSeason.includes(:league).order(created_at: :desc)
      .search params[:q]
    @league_seasons = @search.result.page(params[:page]).
      per Settings.league_seasons.per_page
  end

  def new
    @league_season = @league.league_seasons.build
    @league_season.season_teams.build
  end

  def create
    if @league_season.save
      flash[:success] = t ".success"
      redirect_to :back
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @league_season.update_attributes league_season_params
      flash[:success]= t ".success"
      redirect_to @league_season
    else
      render :edit
    end
  end

  private

  def league_season_params
    params.require(:league_season).permit :league_id, :year,
      season_teams_attributes: [:id, :team_id, :_destroy]
  end

  def load_teams
    @teams = Team.in_country(@league.country_id).pluck :name, :id
  end

  def load_years
    @years = (Time.zone.now.year - Settings.number_of_year)..
      (Time.zone.now.year + Settings.number_of_year)
  end
end
