class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  
  validates :user_id, :vote, presence: true
end
