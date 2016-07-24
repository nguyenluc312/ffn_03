class Admin::TeamsController < ApplicationController
  before_action :load_countries, only: [:new, :edit, :index]
  load_and_authorize_resource

  def index
    @search = Team.includes(:country, :players).order(:name).search params[:q]
    @teams = @search.result.page(params[:page]).per Settings.teams.per_page
  end

  def new
  end

  def create
    if @team.save
      flash[:success] = t ".success"
      redirect_to admin_team_url @team
    else
      load_countries
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
      load_countries
      render :edit
    end
  end

  def show
  end

  def destroy
    if @team.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to :back
  end

  private
  def team_params
    params.require(:team).permit :name, :logo, :full_name, :nickname, :short_name,
      :country_id, :coach, :introduction
  end

  def load_countries
    @countries = Country.all.map {|country| [country.name, country.id]}
  end
end
