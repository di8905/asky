require 'rails_helper'

feature 'create question', %q{
  Authenticated user can create question
  to get help from community
} do
  given(:user) { FactoryGirl.create(:user) }
  
  scenario 'authenticated user creates the question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    
    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create question'
    
    expect(page).to have_content 'Your question successfully added'
    expect(page).to have_content 'Test question title'
  end
  
  scenario 'unauthenticated user tries to create the question' do
    visit questions_path
    click_on 'New question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
  
end
