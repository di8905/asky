require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }
  
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
    before { get :new}
    
    it 'assings new Question to @question variable' do
      expect(assigns(:question)).to be_a_new(Question) 
    end
    
    it 'renders the view new' do
      expect(response).to render_template :new
    end
  end
  
  describe 'GET #edit' do
    before { get :edit, id: question }
    
    it 'assigns to @question variable appropriate question object' do
      expect(assigns(:question)).to eq question 
    end
    
    it 'renders the view edit' do 
      expect(response).to render_template :edit
    end
  end
  
  describe "POST #create" do
    context 'with valid attributes' do 
      it 'saves new question in database' do
        expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(Question, :count).by(1)
        post :create, question: FactoryGirl.attributes_for(:question)
      end
      
      it 'redirects to show view' do
        post :create, question: FactoryGirl.attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end

end
