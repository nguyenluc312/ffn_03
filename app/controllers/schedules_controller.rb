class SchedulesController < ApplicationController
  load_and_authorize_resource :league_season
  before_action :load_leagues

  def show
    @schedule = @league_season.get_schedule
  end

  private
  def load_leagues
    @leagues = League.order(:country_id).includes :league_seasons, :country
  end
end
