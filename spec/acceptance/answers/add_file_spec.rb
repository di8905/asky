require_relative '../acceptance_helper_overrides'

feature 'add file attachment', %q{
  In order to illustrate answer
  user able to add answer
} do
  given(:user) { FactoryGirl.create(:user) }
  given(:question) { FactoryGirl.create(:question, user: user) }
  
  background do
    log_in user
    visit question_path(question)
  end
  
  scenario 'user adds answer with file attachment', js: true do
    fill_in 'Answer:', with: 'Test answer with file attachment'
    attach_file 'File', "#{Rails.root}/config/spring.rb"
    click_on 'Post your answer'
    
      expect(page).to have_link('spring.rb'), href: '/uploads/attachment/file/1/spring.rb'
  end
  
end
