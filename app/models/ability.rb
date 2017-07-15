class Ability
  include CanCan::Ability

  # ============================================================================
  # ENUMS
  # ============================================================================
  STATUS = ["unverified", "verified", "closed"]


  # ============================================================================
  # CLASS - ACTIONS
  # ============================================================================  
  def initialize(user)
    user ||= User.new # guest user

    if user.is_admin_role?
      can :manage, :all
    else
      can :manage, User, id: user.id
      can :manage, Restaurant, user_id: user.id
      case user.status
      when STATUS[0]
        
      when STATUS[1]

      when STATUS[2]
      
      end
    end
  end
end
