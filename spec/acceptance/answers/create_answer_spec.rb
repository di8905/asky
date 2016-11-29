require_relative '../acceptance_helper_overrides'

feature 'create answer', %q{
  User can create answer while in question page
} do 
  
  given(:question) { FactoryGirl.create(:question) }
  given(:user) { FactoryGirl.create(:user) }
  
  scenario 'authenticated user creates the answer', js: true do
    log_in(question.user)
    visit question_path(question)
    fill_in 'Answer:', with: 'Test answer js capybara.'
    click_on('Post your answer')
    within('.answers') { expect(page).to have_content('Test answer js capybara.') }
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'created answer broadcasts to all users without page reloading', js: true do
    Capybara.using_session('user') do
      log_in user
      visit question_path(question)
    end
    
    Capybara.using_session('guest') do
      visit question_path(question)
    end
    
    Capybara.using_session('user') do
      fill_in 'Answer:', with: 'Test answer broadcasting'
      click_on('Post your answer')
      within('.answers') { expect(page).to have_content('Test answer broadcasting') }
    end
    
    Capybara.using_session('guest') do
      within('.answers') { expect(page).to have_content('Test answer broadcasting') }
    end
    
  end
  
  scenario 'unauthenticated user tries to create the answer', js: true do
    visit question_path(question)
    fill_in 'Answer:', with: 'My test answer'
    click_on('Post your answer')
    
    within('.answers') { expect(page).to_not have_content('My test answer') }
  end
  
  scenario 'authenticated user creates the invalid answer', js: true do
    log_in(question.user)
    visit question_path(question)
    fill_in 'Answer:', with: 'My'
    click_on('Post your answer')
    
    expect(page).to have_content('Body is too short (minimum is 3 characters)')
  end
  
end
