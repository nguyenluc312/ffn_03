class Admin::LeagueSeasonsController < ApplicationController
  before_action :load_league, only: [:new, :create, :index]
  before_action :load_teams, only: [:new, :create]
  before_action :load_years, only: [:new, :create]

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

  private
  def load_league
    @league = League.find_by id: params[:league_id]
  end

  def league_season_params
    params.require(:league_season).permit :year,
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
