require_relative '../acceptance_helper_ovverrides'

feature 'add file attachments', %q{
  In order to be able to illustrate
  question, i'd like to be able attach files
} do
  given(:user) { FactoryGirl.create(:user) }
  background do
    log_in(user)
    visit questions_path
    click_on 'New question'
  end
  
  scenario 'user adds file when asks question' do
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    
    expect(page).to have_content(rails_helper.rb)
  end
  
end
