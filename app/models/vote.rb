class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, :vote, presence: true
  validates :user_id, uniqueness: { scope: [:voteable_id, :voteable_type]}
  validates_inclusion_of :vote, in: [-1, 1]
end
