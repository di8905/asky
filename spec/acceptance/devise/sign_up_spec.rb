require 'rails_helper'

feature 'User sign up', %q{
  Guest able to sign up to 
  use all sight features
} do
  
  scenario 'user signs up with appropriate attributes' do
    user_attributes = FactoryGirl.attributes_for(:user)
    visit root_path
    within(".nav", match: :first) { click_on("Sign up") }
    within('form#new_user') do
      fill_in 'Email', with: user_attributes[:email]
      fill_in 'Name',  with: user_attributes[:name]
      fill_in 'Password', with: user_attributes[:password]
      fill_in 'Password confirmation', with: user_attributes[:password_confirmation]
      click_on 'Sign up'
    end
    
    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_content("Log out (#{user_attributes[:name]})")
  end
  
  scenario 'user signs up with inapprorpiate attributes' do
    invalid_user_attributes = FactoryGirl.attributes_for(:invalid_user)
    visit root_path
    within(".nav", match: :first) { click_on("Sign up") }
    within('form#new_user') do
      fill_in 'Email', with: invalid_user_attributes[:email]
      fill_in 'Name',  with: invalid_user_attributes[:name]
      fill_in 'Password', with: invalid_user_attributes[:password]
      fill_in 'Password confirmation', with: invalid_user_attributes[:password_confirmation]
      click_on 'Sign up'
    end
    
    expect(page).to have_content('errors prohibited this user from being saved')
  end
  
  scenario 'user has logged in already and tries to sign up' do
    user = FactoryGirl.create(:user)
    log_in(user)
    visit new_user_session_path
    
    expect(page).to have_content("You are already signed in.")
  end
  
end
