require 'rails_helper'

module AcceptanceHelper
  def log_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within('form#new_user') do
      click_on('Log in')
    end
  end
end
