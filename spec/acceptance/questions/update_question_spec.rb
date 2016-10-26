require_relative '../acceptance_helper'

feature 'update question', %q{
  to be able to correct mistakes, author can edit his question
} do
  given(:question) { FactoryGirl.create(:question) }
  given(:user) { question.user }
  
  scenario 'author edits and updates his question' do
    log_in(user)
    visit question_path(question)
    click_link 'edit question'
    fill_in 'Edit your question:', with: 'New test text for question'
    click_on 'Save'
    
    within '#question' do
      expect page.to have_content 'New test text for question'
      expect page.not_to have_content 'Save'
    end
  end
  
  scenario 'author tries to update his question with invalid attributes'
  scenario 'user does not see edit question button if he is not author'
  scenario 'unauthenticated user does not see edit button'
end
