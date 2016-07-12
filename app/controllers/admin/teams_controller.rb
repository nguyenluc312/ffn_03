class Admin::TeamsController < ApplicationController
  before_action :load_countries, except: [:index, :destroy, :show]
  before_action :check_destroy_team, only: :destroy

  load_and_authorize_resource

  def index
    @teams = Team.order(:name).page(params[:page]).per Settings.per_page
  end

  def new
    @team = Team.new
  end

  def create
    if @team.save
      flash[:success] = t ".success"
      redirect_to admin_team_url @team
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @team.update_attributes team_params
      flash[:success] = t ".success"
      redirect_to admin_team_url @team
    else
      render :edit
    end
  end

  def destroy
    if @team.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to :back
  end

  private
  def team_params
    params.require(:team).permit :name, :country_id, :introduction, :logo
  end

  def load_countries
    @countries = Country.all.map {|country| [country.name, country.id]}
  end

  def check_destroy_team
    if @team.players.count > Settings.min_player_of_team
      flash[:danger] = t ".error"
      redirect_to :back
    end
  end
end
