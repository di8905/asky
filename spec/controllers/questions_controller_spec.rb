require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { FactoryGirl.create(:question_with_answers) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:question) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_question) }
  let(:user) { question.user }

  describe 'GET #index' do
    let(:questions) { FactoryGirl.create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to eq(questions)
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
    
    it 'assigns to @answers variable appropriate answers' do
      expect(assigns(:answers)).to eq question.answers
    end
    
    it 'builds new attachment for answer field' do
      expect(assigns(:question))
    end
    
    it 'sorts the best answer first' do
      question.answers[2].set_best 
      
      expect(assigns(:answers).first.best).to eq true
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
      
      it 'associates current user with question' do
        post :create, question: valid_attributes
        expect(assigns(:question).user_id).to eq @user.id
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
    let(:update_action) do
      patch :update, id: question, question: { title: 'More than 5 letters', body: 'More than 10 letters' }, format: :js
    end
    
    context 'logged in user' do
      before { sign_in question.user }

      describe 'update with valid attributes' do
        before { update_action }
        
        it 'assigns to @question appropriate question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question with given attributes' do
          question.reload
          expect(question.title).to eq('More than 5 letters')
          expect(question.body).to eq('More than 10 letters')
        end

        it 'renders update js template' do
          expect(response).to render_template 'update'
        end
      end
      
      describe 'update with invalid attributes' do
        before { patch :update, id: question, question: invalid_attributes, format: :js }

        it 'does not update question title with invalid attributes' do
          question.reload
          expect(question.title).to eq question.title
        end
        
        it 'does not update question body with invalid attributes' do
          question.reload
          expect(question.body).to eq question.body
        end

        it 'renders js template update' do
          expect(response).to render_template 'update'
        end
      end
    end
    
    context 'non-author user' do
      sign_in_user
      before { update_action }
      
        it 'does not update question from not author' do
          question.reload
          expect(question.body).to eq 'MyText must be at least 10 letters'
        end
        
        it 'renders update js' do
          expect(response).to render_template 'update'
        end
    end
    
    context 'not authenticated user' do
      before { update_action }
      
      it 'does not update question' do
        expect(question.body).to eq 'MyText must be at least 10 letters'
      end
      
      it 'response unauthorised' do
        expect(response.status).to eq (401)
      end
    end
  end

  describe 'DELETE #delete' do
    let(:delete_action) { delete :destroy, id: question }
    before { question }
    
    context 'deletes if request from author' do
      before { sign_in question.user }
      
      it 'deletes the question' do
        expect { delete_action }.to change(Question, :count).by(-1)
      end

      it 'redirects to index of questions' do
        delete_action
        expect(response).to redirect_to questions_path
      end
    end
    
    context 'delete request from not author' do
      sign_in_user
      it 'does not delete question' do
        expect { delete_action }.not_to change(Question, :count)
      end
    end
  end
end
