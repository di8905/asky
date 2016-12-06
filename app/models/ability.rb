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
    non_author_can_vote(Question)
    non_author_can_vote(Answer)
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user: user
    can :set_best, Answer do |answer|
      answer.question.user == user
    end
    can :destroy, Attachment do |attachment|
      attachment.attachable.user == user
    end
  end
  
  def non_author_can_vote(subject)
    can :vote, subject do |obj|
      !user.author_of?(obj)      
    end
  end
end
