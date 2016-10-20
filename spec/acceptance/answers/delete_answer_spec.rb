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
  
  scenario 'only author sees delete button' do
    @user = FactoryGirl.create(:user)
    @answer = FactoryGirl.create(:answer)
    log_in(@user)
    visit question_path(@answer.question)
    
    expect(page).to_not have_content('Delete answer')
  end
  
end
