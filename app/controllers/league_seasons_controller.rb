class LeagueSeasonsController < ApplicationController
  load_and_authorize_resource

  def index
    @search = LeagueSeason.includes(:league).order(created_at: :desc)
      .search params[:q]
    @league_seasons = @search.result.page(params[:page]).
      per Settings.league_seasons.per_page
    @countries = Country.pluck(:name, :id)
  end

  def show
    @matches = @league_season.get_schedule
    @rank = @league_season.get_rank
    respond_to do |format|
      format.html {redirect_to leagues_path}
      format.js
    end
  end
end
