require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask a question as 
  an user, I want to be able to login
} do  
  given(:user) { FactoryGirl.create(:user) } 
  
  scenario 'Registered user trying to sign in' do
    log_in(user)
    
    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end
  
  scenario 'Unregistered user trying to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong_email@test.com'
    fill_in 'Password', with: 'qqqqqqqq'
    within('form#new_user') { click_on 'Log in'}

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end

feature 'User Log out', %q{
  In order to able end session user can be able
  to Log-out
} do
  given(:user) { FactoryGirl.create(:user) } 

  scenario 'Logged-in user clicks logout button' do
    log_in(user)
    click_on 'Log out'
    
    expect(page).to have_content 'Signed out successfully.'    
    expect(current_path).to eq root_path
  end
  
end    
