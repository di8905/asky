require 'rails_helper'

feature 'delete answer', %q{
  only author can delete his answer
} do
    
  let(:delete_action) { click_on('Delete answer', match: :first) } 
    
  scenario 'author deletes his answer' do
    @answer = FactoryGirl.create(:answer)
    @question = @answer.question
    @user = @answer.user
    log_in(@user)
    visit question_path(@question)
  
    expect { delete_action }.to change(Answer, :count).by(-1)
    expect(page).to have_content('Answer deleted')
  end
  
  scenario 'user tries to delete question of another user' do
    @answer = FactoryGirl.create(:answer)
    @question = @answer.question
    @user = FactoryGirl.create(:user)
    log_in(@user)
    visit question_path(@question)
    
    expect { delete_action }.not_to change(Answer, :count)
    expect(page).to have_content("No access to delete this answer")
  end
  
end
