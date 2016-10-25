require_relative '../acceptance_helper'

feature 'update answer', %q{
  in order to be able correct mistakes author can edit his answer
} do
  
  describe 'authenticated user tries to edit answer' do
    given(:answer) { FactoryGirl.create(:answer) }
    given(:user) { answer.user }
    given(:question) { answer.question }
    
    scenario 'author edits his answer', js: true do
      log_in(user)
      visit question_path(answer)
      click_on 'Edit answer'
      fill_in 'Edit your answer:', with: 'New test answer body', match: :first
      click_on 'Save'
      
      within '.answers' do
        expect(page).to have_content('New test answer body')
        expect(page).not_to have_selector('textarea')
        expect(page).not_to have_content(answer.body)
      end
    end
    
    scenario 'author updates his answer with invalid answer'
    scenario 'only author sees edit link'
  end
  
  scenario 'unauthenticated user does not see edit link' 
end
