class DailySchedulesController < ApplicationController

  def show
    @search = Match.search params[:q]
    if @search.start_time_date_equals
      @matches = @search.result.includes(:league_season, :team1, :team2).order(:start_time)
        .group_by{|match| match.league_season}
    end
  end
end
