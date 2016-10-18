require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:question) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_question) }

  describe 'GET #index' do
    let(:questions) { FactoryGirl.create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns to @question variable appropriate question object' do
      expect(assigns(:question)).to eq question
    end

    it 'renders the view show' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assings new Question to @question variable' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders the view new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns to @question variable appropriate question object' do
      expect(assigns(:question)).to eq question
    end

    it 'renders the view edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    
    it 'saves new question in database' do
      expect { post :create, question: valid_attributes }.to change(Question, :count).by(1)
      post :create, question: valid_attributes
    end

    it 'redirects to show view' do
      post :create, question: valid_attributes
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assings new Question to @question variable' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders the view new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns to @question variable appropriate question object' do
      expect(assigns(:question)).to eq question
    end

    it 'renders the view edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    
    context 'with valid attributes' do
      it 'saves new question in database' do
        expect { post :create, question: valid_attributes }.to change(Question, :count).by(1)
        post :create, question: valid_attributes
      end

      it 'redirects to show view' do
        post :create, question: valid_attributes
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not saves the new question in database' do
        expect { post :create, question: invalid_attributes }.to_not change(Question, :count)
      end

      it 're-renders the new view' do
        post :create, question: invalid_attributes
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    
    context 'update with valid attributes' do
      it 'assigns to @question appropriate question' do
        patch :update, id: question, question: valid_attributes
        expect(assigns(:question)).to eq question
      end

      it 'changes question with given attributes' do
        patch :update, id: question, question: { title: 'More than 5 letters', body: 'More than 10 letters' }
        question.reload
        expect(question.title).to eq('More than 5 letters')
        expect(question.body).to eq('More than 10 letters')
      end

      it 'redirects to updated question' do
        patch :update, id: question, question: valid_attributes
        expect(response).to redirect_to question
      end
    end

    context 'update with invalid attributes' do
      before { patch :update, id: question, question: invalid_attributes }

      it 'does not update question with invalid attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText must be at least 10 letters'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    describe 'DELETE #delete' do
      it 'delets the question' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index of questions' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end
end
