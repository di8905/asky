class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers

  validates :name, presence: true, length: { minimum: 3 }
  
  def author_of?(entity)  
    id == entity.try(:user).try(:id)
  end
end
