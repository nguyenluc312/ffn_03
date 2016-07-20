class LeaguesController < ApplicationController
  authorize_resource

  def index
    @leagues = League.includes :league_seasons
  end
end
