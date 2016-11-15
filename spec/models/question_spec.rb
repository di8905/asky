require 'rails_helper'
require_relative 'concerns/voteable_spec'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id}
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should accept_nested_attributes_for :attachments }
  it_behaves_like 'voteable'
  
  # describe 'vote method:' do
  #   let(:question) { FactoryGirl.create(:question) }
  #   let(:user1) { FactoryGirl.create(:user) }
  #   let(:user2) { FactoryGirl.create(:user) }
  #   
  #   it 'sets the rating' do
  #     question.vote(user1.id, 1)
  #     
  #     expect(question.votes.first.vote).to eq(1)
  #   end
  # 
  #   context 'try to vote twice on one question' do
  #     before do
  #       question.vote(user1.id, 1)
  #       question.vote(user1.id, 1)
  #     end
  #     
  #     it 'allows only first vote to affect on rating' do
  #       expect(question.rating).to eq(1)
  #     end
  #     
  #     it 'records only first vote' do
  #       expect(question.votes.length).to eq(1)
  #     end
  #     
  #   end
  #   
  #   it 'revokes vote then user votes like, then votes dislike later' do
  #     question.vote(user1.id, 1)
  #     question.vote(user1.id, -1)
  #     
  #     expect(question.votes.reload).to match_array([])
  #   end
  #   
  #   it 'revokes vote then user votes dislike, then votes like later' do
  #     question.vote(user1.id, -1)
  #     question.vote(user1.id, 1)
  #     
  #     expect(question.votes.reload).to match_array([])
  #   end
  #     
  #   context 'then second like from another user' do
  #     before do
  #       question.vote(user1.id, 1)
  #       question.vote(user2.id, 1)
  #     end 
  #     
  #     it 'makes two vote records' do
  #       expect(question.votes.length).to eq(2)
  #     end
  #     
  #     it 'makes appropriate rating' do
  #       expect(question.rating).to eq(2)
  #     end
  #   end
  #   
  #   context 'if like from author of question' do
  #     before { question.vote(question.user.id, 1) }
  #     
  #     it 'does not make record' do
  #       expect(question.votes).to match_array([])
  #     end
  #     
  #     it 'does not affects on rating' do
  #       expect(question.rating).to eq(0)
  #     end
  #   end
  # end
end
