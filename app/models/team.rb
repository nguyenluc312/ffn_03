class Team < ActiveRecord::Base
  ATTRIBUTES_IN_SEASON = :win_matches, :lose_matches, :goals, :lose_goals,
    :draw_matches, :total_matches, :rank
  belongs_to :country
  has_many :matches
  has_many :players
  has_many :season_teams
  mount_uploader :logo, LogoTeamUploader

  validates :name, presence: true, uniqueness: true, length: {maximum: 200}
  validates :introduction, length: {maximum: 10000}
  validates :country, presence: true

  scope :in_country, ->(country_id){where country_id: country_id}

  class << self
    def add_attributes_season
      ATTRIBUTES_IN_SEASON.each do |attribute|
        attr_accessor "#{attribute}_in_season"
        alias_method "#{attribute}", "#{attribute}_in_season"
        alias_method "#{attribute}=", "#{attribute}_in_season="
      end
    end

    def header_for_stats *attributes
      res = ""
      attributes.each do |attribute|
        res += "<th class='header-#{attribute} stats' title='#{I18n.t 'rank.full_' + attribute.to_s}'
          data:{toggle: {toggle: 'tooltip'}}>#{I18n.t 'rank.' + attribute.to_s}</th>"
      end
      res.html_safe
    end
  end

  add_attributes_season

  def set_init_value
    ATTRIBUTES_IN_SEASON.each do |attribute|
      self.send "#{attribute}_in_season=", 0
    end
  end

  def in_match match
    if self == match.team1
      :team1
    elsif self == match.team2
      :team2
    end
  end

  def score
    win_matches * 3 + draw_matches
  end

  def offset
    goals - lose_goals
  end

  def bind_stats *attributes
    res = ""
    attributes.each do |attribute|
      res += "<td class='#{attribute} stats'>#{self.send attribute}</td>"
    end
    res.html_safe
  end

  def same_achievement? other_team
    score == other_team.score && offset == other_team.offset
  end

  def stats_from_match match
    if pos = in_match(match)
      self.total_matches += 1
      if match.finished?
        self.goals = match.send(pos.to_s + "_goal")
        self.lose_goals = match.team1_goal + match.team2_goal - goals
        if match.winner
          match.winner == self ? self.win_matches += 1 : self.lose_matches += 1
        else
          self.draw_matches += 1
        end
      end
    end
  end

end
