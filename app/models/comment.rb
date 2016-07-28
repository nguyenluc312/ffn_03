class Comment < ActiveRecord::Base
  belongs_to :news
  belongs_to :user
  validates :content, presence: true, length: {minimum: 10, maximum: 500};
  delegate :name, :avatar, to: :user, prefix: true

  include PublicActivity::Model
  tracked only: :create, owner: :user, recipient: :news
end
