class Question < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: {minimum: 10}
  
  has_many :answers, dependent: :destroy
end
