class MatchEvent < ActiveRecord::Base
  belongs_to :match

  validates :time, presence: true
  validates :content, presence: true, length: {maximum: 2000}
end
