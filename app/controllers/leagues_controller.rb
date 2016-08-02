class LeaguesController < ApplicationController
  load_and_authorize_resource

  def index
    @leagues = League.includes :league_seasons
  end

  def show
    @leagues = League.order :country_id
    league_seasons = @league.league_seasons.order year: :desc
    if league_seasons.any?
      redirect_to league_seasons.first
    end
  end
end
