class TeamsController < ApplicationController
  load_and_authorize_resource

  def show
    @players = @team.players.order(:position).includes(:country)
      .group_by{|player| player.position}
  end
end
