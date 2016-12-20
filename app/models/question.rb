class Question < ActiveRecord::Base
  include Voteable
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :user_id, presence: true
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
  
  after_create { Subscription.create(user_id: self.user.id, question_id: id) }
  
  default_scope { order("created_at") }
  
end
