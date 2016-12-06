require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }
  
  describe 'for guest' do
    let(:user) { nil }
    
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    
    it { should_not be_able_to :manage, :all }
  end
  
  describe 'for admin' do
    let(:user) { FactoryGirl.create(:user, admin: true) }
    
    it { should be_able_to :manage, :all }
  end
  
  describe 'for standard user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_question) { FactoryGirl.create(:question, user: user)}
    let(:user_answer) { FactoryGirl.create(:answer, user: user) }
    let(:user_comment) { FactoryGirl.create(:answer_comment, user: user) }
    let(:other_user_question) { FactoryGirl.create(:question) }
    let(:other_user_answer) { FactoryGirl.create(:answer) }
    let(:other_user_comment) { FactoryGirl.create(:answer_comment) }
    
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    
    it { should be_able_to :update, user_question, user: user}
    it { should_not be_able_to :update, other_user_question, user: user }
    it { should be_able_to :destroy, user_question, user: user}
    it { should_not be_able_to :destroy, other_user_question, user: user }
    
    it { should be_able_to :update, user_answer, user: user}
    it { should_not be_able_to :update, other_user_answer, user: user }
    it { should be_able_to :destroy, user_answer, user: user}
    it { should_not be_able_to :destroy, other_user_answer, user: user }
    
    it { should be_able_to :update, user_comment, user: user}
    it { should_not be_able_to :update, other_user_comment, user: user }
    it { should be_able_to :destroy, user_comment, user: user}
    it { should_not be_able_to :destroy, other_user_comment, user: user }
  end
end
