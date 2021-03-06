class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end
  
  def guest_abilities
    can :read, :all
  end
  
  def admin_abilities
    can :manage, :all
  end
  
  def user_abilities
    guest_abilities
    can :me, User
    can :vote, Answer do |answer|
      !user.author_of?(answer)
    end
    can :vote, Question do |question|
      !user.author_of?(question)
    end
    can :create, Subscription
    can :destroy, Subscription, user_id: user.id
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user_id: user.id
    can :set_best, Answer do |answer|
      answer.question.user == user
    end
    can :destroy, Attachment do |attachment|
      attachment.attachable.user == user
    end
  end
end
