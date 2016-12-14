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
    let!(:object) { FactoryGirl.create(:answer) }
    let!(:comments) { FactoryGirl.create_list(:answer_comment, 3, commentable: object)}
    let!(:attachment) { FactoryGirl.create(:attachment, attachable: object) }
    let(:http_method) { :get }
    let(:path) { "/api/v1/answers/#{object.id}" }
    object_attributes = %w(id rating created_at updated_at body question_id user_id best)
    it_behaves_like 'API authenticable'
    it_behaves_like 'API object', object_attributes
  end
  
  describe 'POST /create' do
    let(:question) { FactoryGirl.create(:question) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:answer) }
    let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_answer)}
    let(:http_method) { :post }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
    object_class = Answer
    let(:create_query) { send http_method, path, params: {answer: valid_attributes, format: :json, access_token: access_token.token} }
    let(:invalid_query) { send http_method, path, params: {answer: invalid_attributes, format: :json, access_token: access_token.token} }
    let(:options) { {question: valid_attributes} }
    it_behaves_like 'API authenticable'
    it_behaves_like 'API create object', object_class
  end
end
