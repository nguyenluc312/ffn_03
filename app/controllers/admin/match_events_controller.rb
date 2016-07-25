class Admin::MatchEventsController < Admin::BaseController
  load_and_authorize_resource :match
  load_and_authorize_resource :match_event, through: :match

  def create
    if @match_event.save
      respond_to do |format|
        format.html {redirect_to [:edit, :admin, @match.league_season, @match]}
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end

  end

  private
  def match_event_params
    params.require(:match_event).permit :match_id, :time, :content
  end
end
