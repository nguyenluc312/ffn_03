class Admin::MatchesController < Admin::BaseController
  load_and_authorize_resource :league_season
  load_and_authorize_resource through: :league_season, only: [:new, :create]
  load_and_authorize_resource except: [:new, :create]

  before_action :load_teams, only: [:new, :create]
  before_action :load_statuses, except: [:index, :destroy, :show]
  before_action :build_match_event, only: [:edit, :update]

  def new
    @match = @league_season.matches.build
  end

  def create
    if @match.save
      flash[:success] = t ".success"
      redirect_to edit_admin_match_url @match
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @match.update_attributes match_params
      flash[:success] = t ".success"
      redirect_to [:edit, :admin, @match]
    else
      render :edit
    end
  end

  private
  def build_match_event
    @match_event = MatchEvent.new
  end

  def match_params
    params.require(:match).permit :league_season_id, :team1_id, :team2_id,
      :start_time, :status, :end_time, :team1_odds, :team2_odds, :draw_odds,
      :team1_goal, :team2_goal
  end

  def load_teams
    @teams = Team.in_country(@league_season.league.country_id)
      .map {|team| [team.name, team.id]}
  end

  def load_statuses
    @statuses = Match.statuses.keys.to_a
  end
end
