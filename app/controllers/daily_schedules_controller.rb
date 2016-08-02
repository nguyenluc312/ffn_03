class DailySchedulesController < ApplicationController

  def show
    @search = Match.search params[:q]
    @search.start_time_date_equals ||= Time.zone.now.to_date
    @matches = @search.result.includes(:league_season, :team1, :team2).order(:start_time)
      .group_by{|match| match.league_season}
    @leagues = League.order :country_id
  end
end
