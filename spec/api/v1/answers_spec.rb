require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { FactoryGirl.create(:question) }
    let!(:answers) { FactoryGirl.create_list(:answer, 3, question: question) }
    let(:answer) { answers.last }
    
    context 'unauthorized' do
      it 'returns 401 status then there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status then access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'
        
        expect(response.status).to eq 401
      end
    end
    
    context 'authorized' do
      let!(:access_token) { FactoryGirl.create(:access_token) }
      
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }
      
      it 'returns question answers list' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end
      
      %w(id rating created_at updated_at body question_id user_id best).each do |attr|
        it "has attribite #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/#{0}/#{attr}")
        end
      end
    end
  end
  
  describe "Get /show" do
    let!(:answer) { FactoryGirl.create(:answer) }
    # let!(:question) { answer.question }

    context 'unauthorized' do
      it 'returns 401 status then there is no access token' do
        get "/api/v1/answers/#{answer.id}", format: :json
        
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status then access token is invalid' do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '123456'
        
        expect(response.status).to eq 401
      end
    end
    
    context 'authorized' do
      let!(:access_token) { FactoryGirl.create(:access_token) }
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }
      
      %w(id rating created_at updated_at body question_id user_id best).each do |attr|
        it "has attribite #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
    
  end
end
