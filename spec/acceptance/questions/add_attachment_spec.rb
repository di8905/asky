require_relative '../acceptance_helper_overrides'

feature 'add file attachments', %q{
  In order to be able to illustrate
  question, i'd like to be able attach files
} do
    
  given(:question) { FactoryGirl.create(:question, user: user)}
  given(:user) { FactoryGirl.create(:user) }
  background do
    log_in(user)
  end
  
  scenario 'user adds multiple files when asks new question', js: true do
    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    click_on('add file')
    click_on('add file')
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/public/500.html")
    inputs[1].set("#{Rails.root}/public/404.html}")
    click_on('Create question')
    
    within('div#question') do
      expect(page).to have_link '500.html', href: '/uploads/attachment/file/1/500.html'
      expect(page).to have_link '404.html_', href: '/uploads/attachment/file/2/404.html_'
    end
  end
      
  context 'editing question' do
    background do
      visit question_path(question)
      click_on 'edit question'
      fill_in 'Edit your question title:', with: 'Test question title'
      fill_in 'Edit your question:', with: 'Test question body'
      within('#edit-question-form') { click_on('add file') }
    end
    
    scenario 'user adds multiple files when edits the question', js: true do
      within('#edit-question-form') { click_on('add file') }
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/public/500.html")
      inputs[1].set("#{Rails.root}/public/404.html}")
      click_on 'Save'
      
      within('div#question') do
        expect(page).to have_link '500.html', href: '/uploads/attachment/file/1/500.html'
        expect(page).to have_link '404.html_', href: '/uploads/attachment/file/2/404.html_'
      end
    end
  end
end
