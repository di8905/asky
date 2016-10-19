require 'rails_helper'

feature 'create answer', %q{
  User can create answer while in question page
} do 
  
  scenario 'authenticated user creates the answer' do
    question = FactoryGirl.create(:question)
    log_in(question.user)
    visit question_path(question)
    click_on('Add answer')
    fill_in 'Answer:', with: 'My test answer'
    click_on('Post your answer')
    
    expect(page).to have_content('Your answer have been successfully added')
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'unauthenticated user tries to create the answer' do
    question = FactoryGirl.create(:question)
    visit question_path(question)
    click_on('Add answer')
    
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
  
  scenario 'authenticated user creates the invalid answer' do
    question = FactoryGirl.create(:question)
    log_in(question.user)
    visit question_path(question)
    click_on('Add answer')
    fill_in 'Answer:', with: 'My'
    click_on('Post your answer')
    
    expect(page).to have_content('Errors Answer')
  end
  
end