require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3) }
  
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribed_questions).through(:subscriptions).source(:question) }
  
  describe 'is user author of entity method test' do
    before do 
      @question = FactoryGirl.create(:question)
      @another_question = FactoryGirl.create(:question)
      @user = @question.user  
    end
    
    it 'has appropriate author_of? method (true condition)' do
      expect(@user.author_of?(@question)).to eq true
    end  
    
    it 'has appropriate author_of? method (false condition)' do
      expect(@user.author_of?(@another_question)).to eq false
    end
  end  
  
  describe '.find_for_oauth' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'user@example.com'}) }
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        
        expect(User.find_for_oauth(auth)).to eq user
      end
    end
    
    context 'user has no authorization' do
      context 'user already exists in db by email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email })}
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.not_to change(User, :count)
        end
        
        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
        
        it 'creates authorization with right provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
        
        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end
    
    context 'user does not exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' })}
      
      it 'creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end
      
      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end
      
      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info.email
      end
      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end
      
      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first
        
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
    
  end
end
