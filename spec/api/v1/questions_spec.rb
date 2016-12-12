require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
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
        expect(response.body).to have_json_size(3).at_path("questions")
      end
      
      %w(id title body created_at updated_at user_id rating).each do |attr|
        it "each question contains attr #{attr}" do
          questions.each_with_index do |question, i|
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/#{i}/#{attr}")
          end
        end
      end
      
      context 'question answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end
        
        %w(id created_at updated_at body question_id user_id rating best).each do |attr|
          it "answer contains attr #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
  
  describe 'GET /show' do
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
      let!(:question) { FactoryGirl.create(:question) }
      let!(:answers) { FactoryGirl.create_list(:answer, 3, question: question) }
      let!(:comments) { FactoryGirl.create_list(:question_comment, 3, commentable: question) }
      let!(:attachment) { FactoryGirl.create(:attachment, attachable: question) }
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }
      
      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
      
      %w(id title body created_at updated_at user_id rating).each do |attr|
        it "has attribite #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
      
      context 'question answers' do
        it 'returns list of question answers' do
          expect(response.body).to have_json_size(3).at_path("question/answers")
        end
        
        %w(id created_at updated_at body question_id user_id best).each do |attr|
          it "has answer attribute #{attr}" do
            question.answers.each_with_index do |answer, i|
              expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/#{i}/#{attr}")
            end
          end
        end
      end
      
      context 'question comments' do
        it 'returns list of question comments' do
          expect(response.body).to have_json_size(3).at_path("question/comments")
        end
        
        %w(id body commentable_type commentable_id user_id).each do |attr|
          it "has comment attribute #{attr}" do
            question.comments.each_with_index do |comment, i|
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/#{i}/#{attr}")
            end
          end
        end
      end
      
      context 'question attachments' do
        it 'returns list of question attachments urls' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end
        
        it 'returns question attachment names' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
        
        it 'returns question attachment urls' do
          expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("question/attachments/0/filename")
        end
      end
    end
  end
end
