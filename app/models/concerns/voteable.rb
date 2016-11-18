module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
    
    def vote(user_id, vote)
      if self.user_id == user_id
        self.errors.add(:base, "Can't vote your own!")
      else  
        process_vote(user_id, vote.to_i)
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
    
    def process_vote(user_id, vote)
      vote_collection = self.votes.where(user_id: user_id)
      if vote_collection.empty?
        self.votes.new(user_id: user_id, vote: vote).save!
      else
        self.errors.add(:base, 'Already voted this!') if vote_collection.first.vote == vote
        vote_collection.first.destroy! if vote_collection.first.vote + vote == 0
      end
    end
  end
end
