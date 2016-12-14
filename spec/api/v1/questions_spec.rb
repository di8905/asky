require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    let!(:collection) { FactoryGirl.create_list(:question, 3) }
    let(:http_method) { :get }
    let(:path) { '/api/v1/questions' }
    attributes = %w(id title body created_at updated_at user_id rating)
    it_behaves_like 'API authenticable'
    it_behaves_like 'API collection', attributes
  end
  
  describe 'GET /show' do
    let!(:object) { FactoryGirl.create(:question) }
    let!(:comments) { FactoryGirl.create_list(:question_comment, 3, commentable: object) }
    let!(:answers) { FactoryGirl.create_list(:answer, 3, question: object) }
    let!(:attachment) { FactoryGirl.create(:attachment, attachable: object) }
    let(:http_method) { :get }
    let(:path) { "/api/v1/questions/#{object.id}" }
    object_attributes = %w(id title body created_at updated_at user_id rating answers)
    it_behaves_like 'API authenticable'
    it_behaves_like 'API object', object_attributes
  end
  
  describe 'POST /create' do
    let(:valid_attributes) { FactoryGirl.attributes_for(:question) }
    let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_question) }
    let(:access_token) { FactoryGirl.create(:access_token) }
    let(:http_method) { :post }
    let(:path) { "/api/v1/questions" }
    object_class = Question
    let(:create_query) { send http_method, path, params: {access_token: access_token.token, question: valid_attributes, format: :json} }
    let(:invalid_query) { send http_method, path, params: {access_token: access_token.token, question: invalid_attributes, format: :json} }
    let(:options) { {question: valid_attributes} }
    it_behaves_like 'API authenticable'
    it_behaves_like 'API create object', object_class
  end
end
