require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.perform' do
    it 'should return nil if empty query' do
      expect(Search.perform(' ', 'Questions')).to be_nil
    end
    
    it 'makes context search with contexts filtered' do
      wrong_context_list = %w(Questions Answers Comments Users Wrong)

      expect(ThinkingSphinx).to receive(:search).with('testquery', classes: [Question, Answer, Comment, User])
      Search.perform('testquery', wrong_context_list)
    end
  end
end
