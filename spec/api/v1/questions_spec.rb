require 'rails_helper'

describe 'Questions API' do
  context 'unauthorized' do
    it 'returns 401 status then there is no access token' do
      get '/api/v1/questions', format: :json
      
      expect(response.status).to eq 401
    end
    
    it 'returns 401 status then access token is invalid' do
      get '/api/v1/questions', format: :json, access_token: '123456'
      
      expect(response.status).to eq 401
    end
  end
  
  context 'authorized' do
    let(:access_token) { FactoryGirl.create(:access_token) }
    let!(:questions) { FactoryGirl.create_list(:question, 3) }
    let(:question) { questions.first }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }
    
    before { get '/api/v1/questions', format: :json, access_token: access_token.token }
    
    it 'returns 200 status code' do
      expect(response.status).to eq 200
    end
    
    it 'returns list of questions appropriate size' do
      expect(response.body).to have_json_size(3)
    end
    
    %w(id title body created_at updated_at user_id).each do |attr|
      it "each question contains attr #{attr}" do
        questions.each_with_index do |question, i|
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{i}/#{attr}")
        end
      end
    end
    
    context 'question answers' do
      it 'included in question object' do
        expect(response.body).to have_json_size(1).at_path("0/answers")
      end
      
      %w(id created_at updated_at body question_id user_id best).each do |attr|
        it "answer contains attr #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
        end
      end
    end
    
  end
end
