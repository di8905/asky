class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: {minimum: 10}
end
