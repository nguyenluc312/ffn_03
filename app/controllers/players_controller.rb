class PlayersController < ApplicationController
  load_and_authorize_resource
  before_action :load_countries, only: :index

  def index
    @search = Player.includes(:team, :country).search params[:q]
    @players = @search.result.page(params[:page]).per Settings.players.per_page
  end

  def show
  end

  private
  def load_countries
    @countries = Country.all.map {|country| [country.name, country.id]}
  end
end
