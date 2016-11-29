require_relative '../acceptance_helper_overrides'

feature 'create comment', %q{
  For more useful discussion user can comment answer 
} do 
  
  given(:answer) { FactoryGirl.create(:answer) }
  given(:user) { FactoryGirl.create(:user) }
  
  scenario 'authenticated user creates the answer comment', js: true do
    log_in user
    visit question_path(answer.question)
    within ("#answer-#{answer.id}") do
      click_on('add a comment')
      fill_in 'comment:', with: 'Test answer comment broadcast'
      click_on 'Save'
      
      expect(page).to have_css('p', text: 'Test answer comment broadcast')
    end 
  end
  
  scenario 'created comment broadcasts to all users without page reloading', js: true do
    Capybara.using_session('user') do
      log_in user
      visit question_path(answer.question)
    end
    
    Capybara.using_session('guest') do
      visit question_path(answer.question)
    end
    
    Capybara.using_session('user') do
      within ("#answer-#{answer.id}") do
        click_on('add a comment')
        fill_in 'comment:', with: 'Test answer comment broadcast'
        click_on 'Save'
        
        expect(page).to have_css('p', text: 'Test answer comment broadcast')
      end 
    end
    
    Capybara.using_session('guest') do
      expect(page).to have_css('p', text: 'Test answer comment broadcast')
    end
    
  end
  
  scenario 'unauthenticated user cannot see comment button', js: true do
    visit question_path(answer.question)
    
    within('.answer-buttons') { expect(page).to_not have_content('add a comment') }
  end
  
  scenario 'authenticated user creates the invalid comment', js: true do
    log_in user
    visit question_path(answer.question)
    within ("#answer-#{answer.id}") do
      click_on('add a comment')
      fill_in 'comment:', with: 'Te'
      click_on 'Save'
    end  
    
    expect(page).to have_content('Body is too short (minimum is 3 characters)')  
  end
end
