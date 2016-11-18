require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { FactoryGirl.create(:question)}
  let!(:answer) { FactoryGirl.create(:answer) }
  sign_in_user
   
  describe 'POST #create' do
    let(:valid_answer_action) do
      post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:answer), format: :js
    end
    let(:invalid_answer_action) do
      post :create, question_id: question.id, answer: {body: nil}, format: :js
    end

    context 'with valid attributes' do
      
      it 'saves new answer in database' do
        expect { valid_answer_action }.to change(Answer, :count).by(1)
      end

      it 'renders create.js' do
        valid_answer_action
        expect(response).to render_template 'create'
      end
      
      it 'associates current user with answer' do
        valid_answer_action
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save invalid answer to database' do
        question
        expect { invalid_answer_action }.not_to change(Answer, :count)
      end

      it 'renders temporary error handler' do
        invalid_answer_action
        expect(response).to render_template 'create'
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        sign_in answer.user
        patch :update, id: answer, answer: { body: 'Custom not factored answer' }, format: :js
      end

      it 'assings appropriate answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'updates answer' do
        answer.reload
        expect(answer.body).to eq 'Custom not factored answer'
      end

      it 'renders the update js template' do
        expect(response).to render_template 'update'
      end
    end
    
    context 'if update request from not author' do
      it 'not saves answer' do
        patch :update, question_id: answer.question.id, id: answer, answer: { body: 'Custom not factored answer' }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, question_id: question.id, id: answer, answer: { body: nil }, format: :js
      end

      it 'does not update answer' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'renders update js' do
        expect(response).to render_template 'update'
      end
    end
  end
  
  describe 'PATCH #vote' do
    it 'invokes vote method' do
      expect { patch :vote, id: answer, vote: 1, format: :json }.to change(Vote, :count).by(1)
    end
  end

  describe 'DELETE #delete' do
    let(:delete_action) { delete :destroy, question_id: answer.question.id, id: answer, format: :js }
    
    context 'deletes if request from the author' do 
      before { sign_in answer.user }
      
      it 'deletes the answer' do
        expect { delete_action }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy js template' do
        delete_action
        expect(response).to render_template 'destroy'
      end
    end
    
    context 'try to delete from not author' do
      it 'does not delete answer' do
        expect { delete_action }.not_to change(Answer, :count)
      end
      
      it 'renders answers/destroy js template' do
        delete_action
        expect(response).to render_template('answers/destroy')
      end
    end 
  end

  describe 'PATCH #set_best' do
    let!(:question) { FactoryGirl.create(:question_with_answers) }
    let(:best_answer) { question.answers[2] }
    
    context 'author sets best answer' do
      before do
        @request.env['devide.mapping'] = Devise.mappings[:user]
        sign_in question.user
        patch :set_best, id: best_answer, format: :js
      end
      
      it 'assigns to @answer appropriate answer' do
        expect(assigns(:answer)).to eq best_answer
      end

      it 'sets the best attribute to answer' do
        expect(assigns(:answer).best).to eq(true)
      end

      it 'renders set best js template' do
        expect(response).to render_template 'set_best'
      end
    end
    
    context 'not author tries to set best' do
      before { patch :set_best, id: best_answer, format: :js }
      it 'does not set the best attribute to answer' do
        expect(assigns(:answer).best?).not_to eq(true)
      end
    end
  end
end
