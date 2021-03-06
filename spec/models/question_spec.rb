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
  
  describe 'after create' do
    it 'subscribes author to updates' do
      expect(Subscription).to receive(:create)
      
      FactoryGirl.create(:question)
    end
  end
end
