require 'rails_helper'

feature 'create answer', %q{
  User can create answer while in question page
} do 
  
  scenario 'authenticated user creates the answer', js: true do
    question = FactoryGirl.create(:question)
    log_in(question.user)
    visit question_path(question)
    fill_in 'Answer:', with: 'Test answer js capybara.'
    click_on('Post your answer')
    
    within('.answers') { expect(page).to have_content('Test answer js capybara.') }
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'unauthenticated user tries to create the answer', js: true do
    question = FactoryGirl.create(:question)
    visit question_path(question)
    fill_in 'Answer:', with: 'My test answer'
    click_on('Post your answer')
    
    expect(page).to_not have_content('My test answer')
  end
  
  scenario 'authenticated user creates the invalid answer', js: true do
    question = FactoryGirl.create(:question)
    log_in(question.user)
    visit question_path(question)
    fill_in 'Answer:', with: 'My'
    click_on('Post your answer')
    
    expect(page).to have_content('Body is too short (minimum is 3 characters)')
  end
  
end
