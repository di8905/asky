require 'rails_helper'

feature 'delete answer', %q{
  only author can delete his answer
} do
    
  let(:delete_action) { click_on('Delete answer', match: :first) } 
  
  context 'logged in user' do
    scenario 'author deletes his answer' do
      @answer = FactoryGirl.create(:answer)
      @question = @answer.question
      @user = @answer.user
      log_in(@user)
      visit question_path(@question)
      delete_action
      
      expect(page).not_to have_content(@answer.body)
      expect(page).to have_content('Answer deleted')
    end
    
    scenario 'only author sees delete button' do
      @user = FactoryGirl.create(:user)
      @answer = FactoryGirl.create(:answer)
      log_in(@user)
      visit question_path(@answer.question)
      
      expect(page).to_not have_content('Delete answer')
    end
  end
  
  context 'not logged in user' do
    scenario 'not logged in user cannot see delete button' do
      @answer = FactoryGirl.create(:answer)
      visit question_path(@answer.question)
      
      expect(page).not_to have_content('Delete answer')
    end
  end
  
end
