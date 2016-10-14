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
    let(:valid_answer_action)   { post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:answer) }
    let(:invalid_answer_action) { post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:invalid_answer) }
    
    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { valid_answer_action }.to change(question.answers, :count).by(1)
      end
      
      it 'redirects to matching question' do
        valid_answer_action
        expect(response).to redirect_to question
      end
    end
    
    context 'with invalid attributes' do
      
      it 'does not save invalid answer to database' do
        expect { invalid_answer_action }.not_to change(question.answers, :count)
      end
      
      it 'renders the new view' do
        invalid_answer_action
        expect(response).to render_template :new
      end
      
    end
  end

end
