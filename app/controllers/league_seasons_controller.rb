class LeagueSeasonsController < ApplicationController
  load_and_authorize_resource

  def show
    @schedule = @league_season.get_schedule
    @rank = @league_season.get_rank
    @league_seasons = @league_season.league.league_seasons.order year: :desc
    @leagues = League.order :country_id
  end
end
