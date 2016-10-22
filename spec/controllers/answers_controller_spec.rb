require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { FactoryGirl.create(:question)}
  let(:answer) { FactoryGirl.create(:answer) }
  sign_in_user
   
  describe 'POST #create' do
    let(:valid_answer_action) do
      post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:answer)
    end
    let(:invalid_answer_action) do
      post :create, question_id: question.id, answer: {body: nil}
    end

    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { valid_answer_action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to matching question' do
        valid_answer_action
        expect(response).to redirect_to question
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

      it 'renders the new view' do
        invalid_answer_action
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        patch :update, question_id: answer.question.id, id: answer, answer: { body: 'Custom not factored answer' }
      end

      it 'updates answer' do
        answer.reload
        expect(answer.body).to eq 'Custom not factored answer'
      end

      it 'redirects to question' do
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, question_id: question.id, id: answer, answer: { body: nil }
      end

      it 'does not update answer' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 're-renders form edit' do
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #delete' do
    context 'deletes if request from the author' do 
      let(:delete_action) do 
        sign_in answer.user
        delete :destroy, question_id: answer.question.id, id: answer 
      end
      
      it 'deletes the answer' do
        answer
        expect { delete_action }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete_action
        expect(response).to redirect_to answer.question
      end
    end
    
    context 'try to delete from not author' do

      it 'does not delete answer' do
        answer
        expect { delete :destroy, question_id: answer.question.id, id: answer }.not_to change(Answer, :count)
      end
      
      it 'redirects to question' do
        delete :destroy, question_id: answer.question.id, id: answer
        expect(response).to redirect_to answer.question
      end
    end 
  end
end
