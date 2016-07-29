class Team < ActiveRecord::Base
  ATTRIBUTES_IN_SEASON = :win_matches, :lose_matches, :goals, :lose_goals,
    :draw_matches, :rank
  belongs_to :country
  has_many :matches, dependent: :destroy
  has_many :season_teams, dependent: :destroy
  has_many :players
  mount_uploader :logo, LogoTeamUploader

  validates :name, :full_name, presence: true, uniqueness: {case_sensitive: false},
    length: {maximum: 100}
  validates :short_name, uniqueness: {case_sensitive: false}
  validates :introduction, length: {maximum: 1000}
  validates :country, :logo, presence: true
  validate :image_size

  scope :in_country, ->(country_id){where country_id: country_id}

  delegate :name, to: :country, prefix: true
  after_destroy :remove_players

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

  def total_matches
    win_matches + lose_matches + draw_matches
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

  private
  def image_size
    if logo.size > Settings.image.max_capacity.megabytes
      errors.add :logo,
        I18n.t("error_capacity_image", maximum: Settings.image.max_capacity)
    end
  end

  def remove_players
    if self.players.any?
      self.players.update_all team_id: nil
    end
  end
end
