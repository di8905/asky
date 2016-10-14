require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }
  let(:answer) { question.answers.create(FactoryGirl.attributes_for(:answer)) }

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
    let(:valid_answer_action) do
      post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:answer)
    end
    let(:invalid_answer_action) do
      post :create, question_id: question.id, answer: FactoryGirl.attributes_for(:invalid_answer)
    end

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
        expect { invalid_answer_action }.not_to change(Answer, :count)
      end

      it 'renders the new view' do
        invalid_answer_action
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        patch :update, question_id: question.id, id: answer, answer: { body: 'Custom not factored answer' }
      end

      it 'updates answer' do
        answer.reload
        expect(answer.body).to eq 'Custom not factored answer'
      end

      it 'redirects to question' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, question_id: question.id, id: answer, answer: { body: nil }
      end

      it 'does not update answer' do
        answer.reload
        expect(answer.body).to eq 'My text'
      end

      it 're-renders form edit' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #delete' do
    let(:delete_action) { delete :destroy, question_id: question.id, id: answer }
    it 'deletes the answer' do
      answer
      expect { delete_action }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question' do
      delete_action
      expect(response).to redirect_to question
    end
  end
end
