class Admin::TeamsController < ApplicationController
  before_action :load_countries, except: [:index, :destroy, :show]
  before_action :load_team, only: [:show, :edit, :update]

  def new
    @team = Team.new
  end

  def create
    @team = Team.new team_params
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

  private
  def team_params
    params.require(:team).permit :name, :country_id, :introduction, :logo
  end

  def load_countries
    @countries = Country.all.map {|country| [country.name, country.id]}
  end

  def load_team
    @team = Team.find_by id: params[:id]
    unless @team
      flash[:warning] = t ".warning"
      redirect_to admin_root_url
    end
  end
end
