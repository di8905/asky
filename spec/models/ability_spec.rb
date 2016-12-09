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
    let(:answer) { FactoryGirl.create(:answer, question: user_question)}
    
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :me, User }
    it { should be_able_to :set_best, answer}
    it { should_not be_able_to :set_best, other_user_answer }
    it { should be_able_to :destroy, Attachment.new(attachable: user_answer) }
    it { should_not be_able_to :destroy, Attachment.new(attachable: other_user_answer) }
        
    [Question, Answer, Comment].each do |subject|
      it { should be_able_to :create, subject }
    end
    
    %i(user_question user_answer).each do |subject|
      it { should_not be_able_to :vote, subject, user: user }
      it { should be_able_to :vote, other_user_question, user: user }
    end
    
    %i(update destroy).each do |action|
      %i(user_question user_answer user_comment).each do |subject|
        it { should be_able_to action, send(subject), user: user}
      end
      %i(other_user_question other_user_answer other_user_comment).each do |subject|
        it { should_not be_able_to action, send(subject), user: user}
      end
    end
  end
end
