class Question < ActiveRecord::Base
  include Voteable
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :user_id, presence: true
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
end
