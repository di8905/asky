require 'rails_helper'
require_relative 'concerns/voteable_spec'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id}
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }
  it_behaves_like 'voteable'
  
  describe '#subscribe' do
    let(:question) { FactoryGirl.create(:question) }
    let(:user) { FactoryGirl.create(:user) }
    
    it 'creates subscription' do
      expect { question.subscribe(user) }.to change(Subscription, :count).by(1)
    end
    
    it 'subscribes user to question' do
      question.subscribe(user)
      expect(user.subscribed_questions).to include(question)
    end
    
    it 'add error to question object if already subscribed' do
      question.subscribe(user)
      question.subscribe(user)
      expect(question.errors.messages[:base]).to include("Already subscribed!")
    end
    
    it 'it does not create subscription if already subscribed' do
      question.subscribe(user)
      expect { question.subscribe(user) }.not_to change(Subscription, :count)
    end
  end
  
end
