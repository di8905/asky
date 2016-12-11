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
    
    it 'returns 200 status code' do
      get '/api/v1/questions', format: :json, access_token: access_token
    end
  end
end
