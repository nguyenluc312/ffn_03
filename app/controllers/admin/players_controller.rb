class Admin::PlayersController < ApplicationController
  before_action :load_countries, :load_positions, only: [:new , :edit]
  load_and_authorize_resource

  def new
  end

  def create
    if @player.save
      flash[:success] = t ".success"
    else
      load_countries
      load_positions
      render :new
    end
  end

  def edit
  end

  def update
    if @player.update_attributes player_params
      flash[:success] = t ".success"
    else
      load_countries
      load_positions
      render :edit
    end
  end

  private
  def player_params
    params.require(:player).permit :name, :avatar, :date_of_birth, :country_id,
      :height, :weight, :position, :introduction
  end

  def load_countries
    @countries = Country.order(:name).map{|country| [country.name, country.id]}
  end

  def load_positions
    @positions = Player.positions.keys.to_a
  end
end
