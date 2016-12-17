class Subscription < ApplicationRecord
  has_many :users, through: :subscriptions_users
  has_many :subscriptions_users
  
  validates :question_id, presence: true
end
