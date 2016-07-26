module ApplicationHelper

  def link_to_add_fields name, f, association
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: "add_fields btn btn-success no-radius",
      data: {id: id, season_teams: fields.gsub("\n", "")})
  end

  def show_activity activity
    if activity.trackable_type == UserBet.name
      (t("activity.bet", chosen: activity.trackable.chosen) +
        link_to(t("activity.match"), activity.recipient) + " " +
        link_to(image_tag(activity.recipient.team1.logo.url,
          size: Settings.activity.logo_team), activity.recipient.team1) +
        t("activity.vs") +
        link_to(image_tag(activity.recipient.team2.logo.url,
          size: Settings.activity.logo_team), activity.recipient.team2) +
        t("activity.coin", coin: activity.trackable.coin)
      ).html_safe
    elsif activity.trackable_type == Comment.name
      (t("activity.comment") + " " + link_to(t("activity.post"), activity.recipient))
       .html_safe
    end
  end
end
