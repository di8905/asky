require_relative '../acceptance_helper'

feature 'update question', %q{
  to be able to correct mistakes, author can edit his question
} do
  given(:question) { FactoryGirl.create(:question) }
  given(:user) { question.user }
  
  scenario 'author edits and updates his question', js: true do
    log_in(user)
    visit question_path(question)
    click_link 'edit question'
    fill_in 'Edit your question title:', with: 'New test question title'
    fill_in 'Edit your question:', with: 'New test text for question body'
    click_on 'Save'
    
    within('h1') { expect(page).to have_content 'New test question title' }
    within('#question') { expect(page).to have_content 'New test text for question body' }
    expect(page).not_to have_content 'Save'
    expect(page).to have_content 'edit question'
  end
  
  scenario 'author tries to update his question with invalid attributes', js: true do
    log_in(user)
    visit question_path(question)
    click_link 'edit question'
    fill_in 'Edit your question title:', with: 'Ne'
    fill_in 'Edit your question:', with: 'New '
    click_on 'Save'
  
    within('#errors') do
      expect(page).to have_content 'Body is too short'
      expect(page).to have_content 'Title is too short'
    end
  end
  
  scenario 'user does not see edit question button if he is not author' do
    log_in(user)
    visit question_path( FactoryGirl.create(:question) )
    
    expect(page).not_to have_content 'edit question'
  end
  
  scenario 'unauthenticated user does not see edit button' do
    visit question_path( FactoryGirl.create(:question) )
    
    expect(page).not_to have_content 'edit question'
  end
end
