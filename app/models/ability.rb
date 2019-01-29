class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :super
      can :manage, :all

      can :access, :rails_admin
      can :dashboard
    end
    if user.role? :admin
      can :manage, :all
    end

    can :read, :all
  end
end
