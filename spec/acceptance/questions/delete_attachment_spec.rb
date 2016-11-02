require_relative '../acceptance_helper_overrides'

feature 'delete question attachments', %q{
  In order to correct mistakes author able
  to delete attachment
} do
  
  given(:question) { FactoryGirl.create(:question)}
  given(:another_user) { FactoryGirl.create(:user) }
  
  background do
    log_in question.user
    visit question_path(question)
    click_on 'edit question'
    fill_in 'Edit your question title:', with: 'Test question title'
    fill_in 'Edit your question:', with: 'Test question body'
    within('#edit-question-form') { click_on('add file') }
    attach_file 'File', "#{Rails.root}/public/500.html"
    click_on('Save')
  end
  
  scenario 'author deletes attachment', js: true do
    within('#attachments') { click_on('[x]') }

    expect(page).not_to have_content('500.html')
  end
  
  scenario 'non-author cannot see delete attachment button', js: true do
    click_on('Log out')
    log_in another_user
    visit question_path(question)

    within('#attachments') do
      expect(page).not_to have_content('[x]')
    end
  end
  
end
