class Admin::MatchesController < ApplicationController
  load_and_authorize_resource

  before_action :load_league_season, :load_teams,
    only: [:new, :create]

  def new
    @match = @league_season.matches.build
  end

  def create
    if @match.save
      flash[:success] = t ".success"
      redirect_to new_admin_league_season_match_url
    else
      render :new
    end
  end

  private
  def match_params
    params.require(:match).permit :league_season_id, :team1_id, :team2_id,
      :start_time, :team1_odds, :team2_odds, :draw_odds, :team1_goal, :team2_goal
  end

  def load_league_season
    @league_season = LeagueSeason.find params[:league_season_id]
  end

  def load_teams
    @teams = Team.in_country(@league_season.league.country_id)
      .map {|team| [team.name, team.id]}
  end
end
