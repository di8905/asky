class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  EMAIL = /.+@.+\..+/i

  has_many :questions
  has_many :answers

  validates :name, :email, :password, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :name, length: { minimum: 3 }
  validates :password, length: { minimum: 6}
  validates :email, format: { with: EMAIL, message: 'incorrect email' }
end
