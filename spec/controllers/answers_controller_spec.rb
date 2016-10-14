require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }

  describe 'GET #new' do
    before { get :new, question_id: question.id }
    
    it 'assigns appropriate @question variable to make new answer' do
      expect(assigns(:question)).to eq question
    end
    
    it 'assigns new Answer to @answer variable' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    
    it 'is associated with @question' do
      expect(assigns(:answer).question).to eq question
    end
    
    it 'render view :new' do
      expect(response).to render_template :new
    end
  end
      
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end
      
      it 'redirects to matching question' do
        post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end
    
    context 'with invalid attributes' do
      let(:invalid_attrbutes) { FactoryGirl.attributes_for(:invalid_answer) }
      
      it 'does not save invalid answer to database' do
        expect { post :create, question_id: question.id, answer: invalid_attrbutes }.not_to change(question.answers, :count)
      end
      
      it 'renders the new view' do
        post :create, question_id: question.id, answer: invalid_attrbutes
        expect(response).to render_template :new
      end
      
    end
  end

end
