require 'rails_helper'

shared_examples_for "voteable" do
  let(:model) { FactoryGirl.create(described_class.to_s.underscore.to_sym) }
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  
  describe 'vote method tests' do
    it 'sets the rating' do
      model.vote(user1.id, 1)
      
      expect(model.rating).to eq(1)
    end
    
    context 'if one user tries to vote twice' do
      before do
        model.vote(user1.id, 1)
        model.vote(user1.id, 1)
      end
      
      it 'only one vote affects to rating' do
        expect(model.rating).to eq(1)
      end
      
      it 'only first vote be recorded in database' do
        expect(model.votes.length).to eq(1)
      end
    end
    
    it 'destroys vote if user revokes vote' do
      model.vote(user1.id, 1)
      model.vote(user1.id, -1)
      
      expect(model.votes.reload).to match_array([])
    end
    
    context 'votes from different users' do
      before do
        model.vote(user1.id, 1)
        model.vote(user2.id, 1)
      end
      
      it 'sets appropriate rating' do
        expect(model.rating).to eq(2)
      end
      
      it 'makes two records in db' do
        expect(model.votes.length).to eq(2)
      end
    end
    
    context 'if author tries to vote own entity' do
      before { model.vote(model.user.id, 1) }
      
      it 'does not affects to rating' do
        expect(model.rating).to eq(0)
      end
      
      it 'does note make record to db' do
        expect(model.votes.length).to eq(0)
      end
    end
  end
  
  describe 'rating method tests' do
    it 'has rating method' do
      expect(model.rating).to eq(0)
    end
    
    context 'calculates rating right' do
    before { model.vote(user1.id, 1) }
          
      it 'worsk with summation' do
        model.vote(user2.id, 1)
        
        expect(model.rating).to eq(2)
      end
      
      it 'worsk with substraction' do
        model.vote(user2.id, -1)
        expect(model.rating).to eq(0)
      end
    end
  end
end
