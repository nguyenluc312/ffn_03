class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new # guest user (not logged in)
    case
    when user.admin?
      can :manage, :all
      cannot :destroy, User do |user|
        user.admin? || user.moderate?
      end
      cannot :update, Comment do |comment|
        comment.user != user
      end
    when user.moderate?
      can :manage, News
      can :destroy, Comment
    when user.user?
      can :read, :all
      can :create, Comment
      can [:update, :destroy], Comment, user_id: user.id
      can :create, UserBet
    else
      can :read, :all
    end
  end
end

