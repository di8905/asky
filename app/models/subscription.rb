class Subscription < ApplicationRecord
  has_and_belongs_to_many :users
  
  validates :question_id, presence: true
end
