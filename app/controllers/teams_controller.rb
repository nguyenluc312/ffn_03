class TeamsController < ApplicationController
  load_and_authorize_resource
  before_action :load_countries, only: :index

  def index
    @search = Team.includes(:country, :players).order(:name).search params[:q]
    @teams = @search.result.page(params[:page]).per Settings.teams.per_page
  end

  def show
    @players = @team.players.order(:position).includes(:country)
      .group_by{|player| player.position}
  end

  private
  def load_countries
    @countries = Country.all.map {|country| [country.name, country.id]}
  end
end
