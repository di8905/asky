require_relative '../acceptance_helper_overrides'

feature 'create comment', %q{
  For more useful discussion user can comment question 
} do 
  
  given(:question) { FactoryGirl.create(:question) }
  given(:user) { FactoryGirl.create(:user) }
  
  scenario 'authenticated user creates the question comment', js: true do
    log_in user
    visit question_path(question)
    within ('#question-buttons') { click_on 'add a comment'}
    within('.question-comments') do
      fill_in 'comment', with: 'Testing question comment'
      click_on('Save')
      
      expect(page).to have_css('p', text: 'Testing question comment')
    end 
  end
  
  scenario 'created comment broadcasts to all users without page reloading', js: true do
    Capybara.using_session('user') do
      log_in user
      visit question_path(question)
    end
    
    Capybara.using_session('guest') do
      visit question_path(question)
    end
    
    Capybara.using_session('user') do
      within ('#question-buttons') { click_on 'add a comment'}
      within('.question-comments') do
        fill_in 'comment', with: 'Testing question broadcasting comment'
        click_on('Save')
        
        expect(page).to have_css('p', text: 'Testing question broadcasting comment')
      end
    end
    
    Capybara.using_session('guest') do
      within('.question-comments') { expect(page).to have_css('p', text: 'Testing question broadcasting comment') }
    end
    
  end
  
  scenario 'unauthenticated user cannot see comment button', js: true do
    visit question_path(question)
    
    within('#question') { expect(page).to_not have_content('add a comment') }
  end
  
  scenario 'authenticated user creates the invalid comment', js: true do
    log_in user
    visit question_path(question)
    within ('#question-buttons') { click_on 'add a comment'}
    within('.question-comments') do
      fill_in 'comment', with: 'Te'
      click_on('Save')
    end
    
    expect(page).to have_content('Body is too short (minimum is 3 characters)')
  end
  
end
