class LeagueSeasonsController < ApplicationController
  load_and_authorize_resource

  def show
    @matches = @league_season.get_schedule
    @rank = @league_season.get_rank
    respond_to do |format|
      format.html {redirect_to leagues_path}
      format.js
    end
  end
end
