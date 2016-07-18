class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new # guest user (not logged in)
    case
    when user.admin?
      can :manage, :all
    when user.user?
      can :read, :all
      can :create, Comment
      can [:update, :destroy], Comment, user_id: user.id
    else
      can :read, :all
    end
  end
end
