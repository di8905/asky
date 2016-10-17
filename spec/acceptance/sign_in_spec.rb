require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask a question as 
  an user, I want to be able to login
} do
  
  scenario 'Registered user trying to sign in' do
    User.create!(email: 'user@test.com', password: '12345678')
    
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Sign in'
    
    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end
  
  scenario 'Unregistered user trying to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong_email@test.com'
    fill_in 'Password', with: 'qqqqqqqq'
    
    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end

  
  
  
  
  
  
  
  
end
