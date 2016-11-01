require_relative '../acceptance_helper_overrides'

feature 'delete answer attachments', %q{
  In order to correct mistakes author able
  to delete attachment
} do

  given(:question) { FactoryGirl.create(:question) }
  given(:user) { FactoryGirl.create(:user) }
  given(:another_user) { FactoryGirl.create(:user) }
  
  background do
    log_in user
    visit question_path(question)
    fill_in 'Answer', with: 'Test answer with attachment text'
    within('.new_answer') do
      click_on('add file')
      attach_file 'File', "#{Rails.root}/public/500.html"
      click_on('Post your answer')
    end
  end
  
  scenario 'author deletes attachment', js: true do
    within("#answers") { click_on('[x]') }

    expect(page).not_to have_content('500.html')
  end
  
  scenario 'non-author cannot see delete attachment button', js: true do
    click_on('Log out')
    log_in another_user
    visit question_path(question)

    within('#answers') do
      expect(page).not_to have_content('[x]')
    end
  end
  
end
