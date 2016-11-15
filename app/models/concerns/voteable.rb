module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
    
    def vote(user_id, vote)
      vote_record = self.votes.where(user_id: user_id).reload
      return "can't vote your own" if self.user_id == user_id
      if vote_record.empty?
        self.votes.new(user_id: user_id, vote: vote).save!
      else
        vote_record.first.vote == vote ? "error: vote exists" : vote_record.first.destroy
      end
    end
    
    def rating
      sum = 0
      reload
      self.votes.each do |record|
        sum += record.vote
      end
      sum
    end
  end
end
