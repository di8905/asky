module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
    
    def vote(user, vote)
      if self.user.id == user.id
        self.errors.add(:base, "Can't vote your own!")
      else  
        process_vote(user, vote.to_i)
      end
    end
    
    def rating
      sum = 0
      self.votes.each do |record|
        sum += record.vote
      end
      sum
    end
    
    private
    
    def process_vote(user, vote)
      vote_collection = self.votes.where(user_id: user.id)
      if vote_collection.empty?
        self.votes.new(user_id: user.id, vote: vote).save!
      else
        self.errors.add(:base, 'Already voted this!') if vote_collection.first.vote == vote
        vote_collection.first.destroy! if vote_collection.first.vote + vote == 0
      end
    end
  end
end
