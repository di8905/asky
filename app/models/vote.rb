class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user
  
  validates :user_id, :vote, presence: true
  validates :user_id, uniqueness: { scope: :voteable }
end
