class SubscriptionsUser < ApplicationRecord
  belongs_to :user
  belongs_to :subscription
  validates :user_id , uniqueness: { scope: :subscription_id }
end
