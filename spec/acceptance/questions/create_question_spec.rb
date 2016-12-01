require_relative '../acceptance_helper_overrides'

feature 'create question', %q{
  Authenticated user can create question
  to get help from community
} do
  given(:user) { FactoryGirl.create(:user) }
  
  scenario 'authenticated user creates the question' do
    log_in(user)
    
    visit questions_path
    click_on 'New question', match: :first
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create question'
    
    expect(page).to have_content 'Question was successfully created'
    expect(page).to have_content 'Test question title'
    expect(page).to have_content 'Test question body'
  end
  
  scenario 'authenticated user creates the invalid question' do
    log_in(user)
    visit questions_path
    click_on 'New question', match: :first
    fill_in 'Title', with: ' '
    fill_in 'Body', with: ' '
    click_on 'Create question'
    
    expect(page).to have_content('Errors Question')
  end
  
  scenario 'unauthenticated user tries to create the question' do
    visit questions_path
    click_on 'New question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
  
  context 'different sessions' do
    scenario 'created question appears on another user\'s question list', js: true do
      Capybara.using_session('user') do
        log_in(user)
        visit questions_path
      end
      
      Capybara.using_session('guest') do
        visit questions_path
      end
      
      Capybara.using_session('user') do
        click_on 'New question', match: :first
        fill_in 'Title', with: 'Test action cable question'
        fill_in 'Body', with: 'Test question body'
        click_on 'Create question'
        
        expect(page).to have_content 'Question was successfully created'
        expect(page).to have_content 'Test action cable question'
        expect(page).to have_content 'Test question body'
      end
      
      Capybara.using_session('guest') do
        expect(page).to have_content 'Test action cable question'
      end
    end
  end
  
end
