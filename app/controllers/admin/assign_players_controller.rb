class Admin::AssignPlayersController < ApplicationController

  load_resource :team, only: [:show, :new, :create]
  load_and_authorize_resource :player, only: [:create, :update, :destroy]
  before_action :load_countries, only: :new


  def new
    @search = Player.free.includes(:country).search params[:q]
    @players = @search.result.page(params[:page]).per Settings.players.per_page
  end

  def create
    if @player.update_attributes assign_player_params
      flash[:success] = t ".success"
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    @players = @team.players.order(:position, :squad_number).includes :country
  end

  def update
    if @player.update_attributes assign_player_params
      flash[:success] = t ".success"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @player.update_attributes team_id: nil
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to :back
  end

  private
  def load_countries
    @countries = Country.order(:name).map{|country| [country.name, country.id]}
  end

  def assign_player_params
    params.permit :squad_number, :joined_at, :team_id
  end
end

