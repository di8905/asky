require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { FactoryGirl.create(:question) }
    let!(:collection) { FactoryGirl.create_list(:answer, 3, question: question) }
    let(:http_method) { :get }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
    attributes = %w(id rating created_at updated_at body question_id user_id best)
    it_behaves_like 'API authenticable'
    it_behaves_like 'API collection', attributes
  end
  
  describe "Get /show" do
    let!(:answer) { FactoryGirl.create(:answer) }
    let!(:comments) { FactoryGirl.create_list(:answer_comment, 3, commentable: answer)}
    let(:comment) { comments.last }
    let!(:attachment) { FactoryGirl.create(:attachment, attachable: answer) }
    let(:http_method) { :get }
    let(:path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API authenticable'
    
    context 'authorized' do
      let!(:access_token) { FactoryGirl.create(:access_token) }
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }
      
      %w(id rating created_at updated_at body question_id user_id best).each do |attr|
        it "has attribite #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
      
      context 'answer comments' do
        it 'includes answer comments list' do
          expect(response.body).to have_json_size(3).at_path("answer/comments")
        end
        
        %w(id body commentable_type commentable_id user_id).each do |attr|
          it "includes comment attribite #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end
      
      context 'answer attachments' do
        it 'returns answer attachments names' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
        
        it 'returns question attachments urls' do
          expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("answer/attachments/0/filename")
        end
      end
    end
  end
  
  describe 'POST /create' do
    let!(:access_token) { FactoryGirl.create(:access_token) }
    let(:question) { FactoryGirl.create(:question) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:answer) }
    let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_answer)}
    let(:create_query) { post "/api/v1/questions/#{question.id}/answers", params: {answer: valid_attributes, format: :json, access_token: access_token.token} }
    let(:invalid_query) { post "/api/v1/questions/#{question.id}/answers", params: {answer: invalid_attributes, format: :json, access_token: access_token.token} }
    let(:http_method) { :post }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
    let(:options) { {question: valid_attributes} }
    it_behaves_like 'API authenticable'
    
    context 'authorized' do
      it 'creates new answer in db with valid query' do
        expect { create_query }.to change(Answer, :count).by(1)
      end
      
      it 'does not creates question in db with invalid question parameters' do
        expect { invalid_query }.not_to change(Answer, :count)
      end
      
      it 'returns 422 status with invalid question parameters' do
        invalid_query
        expect(response.status).to eq 422
      end
    end
  end
end
