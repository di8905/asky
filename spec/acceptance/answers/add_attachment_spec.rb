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
    click_on 'add file'
    click_on 'add file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/public/500.html")
    inputs[1].set("#{Rails.root}/public/404.html}")
    click_on 'Post your answer'
    
    within('.answers') do
      expect(page).to have_link '500.html', href: '/uploads/attachment/file/1/500.html'
      expect(page).to have_link '404.html_', href: '/uploads/attachment/file/2/404.html_'
    end
  end
end
