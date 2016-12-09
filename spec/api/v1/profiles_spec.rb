require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if no access token' do
        get '/api/v1/profiles/me', format: :json
        
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status if access token invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '1234'
        
        expect(response.status).to eq 401
      end
    end
    
    context 'authorized' do
      let(:me) { FactoryGirl.create(:user) }
      let(:access_token) { FactoryGirl.create(:access_token, resource_owner_id: me.id) }
      
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }
      
      it 'returns 200 status' do
        expect(response).to be_success
      end
      
      %w(email id created_at updated_at admin name).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end
      
      %w(password encrypted_password).each do |attr|
        it 'does not contain password' do
          expect(response.body).not_to have_json_path(attr)
        end
      end
    end
  end
  
  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if no access token' do
        get '/api/v1/profiles', format: :json
        
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status if access token invalid' do
        get '/api/v1/profiles', format: :json, access_token: '1234'
        
        expect(response.status).to eq 401
      end
    end
    
    context 'authorized' do
      let(:me) { FactoryGirl.create(:user) }
      let!(:users) { FactoryGirl.create_list(:user, 3) }
      let(:access_token) { FactoryGirl.create(:access_token, resource_owner_id: me.id) }
      
      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }
      
      it 'returns 200 status' do
        expect(response).to be_success
      end
      
      it 'contains users profiles except me' do
        expect(response.body).to be_json_eql(users.to_json)
      end
      
      it 'contains users profiles except me' do
        expect(response.body).to_not include_json(me.to_json)
      end
      
      %w(email id created_at updated_at admin name).each do |attr|
        it "each record contains attribute #{attr}" do
          users.each_with_index do |user, i| 
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{i}/#{attr}")
          end
        end
      end
      
      %w(password encrypted_password).each do |attr|
        it "each user does not contain attribute #{attr}" do
          users.each_index do |i|
            expect(response.body).not_to have_json_path("#{i}/#{attr}")
          end
        end
      end
    end
  end
end
