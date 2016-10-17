class User < ActiveRecord::Base
  EMAIL = /.+@.+\..+/i

  has_many :questions
  has_many :answers

  validates :name, :email, :password, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :name, length: { minimum: 3 }
  validates :password, length: { minimum: 6}
  validates :email, format: { with: EMAIL, message: 'incorrect email' }
end
