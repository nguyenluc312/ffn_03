class Admin::LeagueSeasonsController < Admin::BaseController
  before_action :load_league, except: [:show, :destroy]
  before_action :load_years, :load_teams, except: [:index, :destroy, :show]

  load_and_authorize_resource

  def index
    @league_seasons = @league.league_seasons.order(created_at: :desc)
      .page(params[:page]).per Settings.per_page
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
  def load_league
    @league = League.find_by id: params[:league_id]
  end

  def league_season_params
    params.require(:league_season).permit :league_id, :year,
      season_teams_attributes: [:id, :team_id, :_destroy]
  end

  def load_teams
    @teams = Team.in_country(@league.country_id)
      .map {|team| [team.name, team.id]}
  end

  def load_years
    @years = (Time.zone.now.year - Settings.number_of_year)..
      (Time.zone.now.year + Settings.number_of_year)
  end
end
