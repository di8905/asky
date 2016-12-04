class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations

  validates :name, presence: true, length: { minimum: 3 }
  
  def author_of?(entity)  
    id == entity.try(:user_id)
  end
  
  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization 
    
    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid) if user
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, name: auth.info.name, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end
end
