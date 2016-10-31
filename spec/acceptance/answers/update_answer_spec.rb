require_relative '../acceptance_helper_overrides'

feature 'update answer', %q{
  in order to be able correct mistakes author can edit his answer
} do
  
  given(:answer) { FactoryGirl.create(:answer) }
  given(:user) { answer.user }
  given(:question) { answer.question }
  
  describe 'authenticated user tries to edit answer' do
    scenario 'author edits his answer', js: true do
      log_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      fill_in 'Edit your answer:', with: 'New test answer body', match: :first
      click_on 'Save'
      
      within '.answers' do
        expect(page).to have_content('New test answer body')
        expect(page).not_to have_selector('textarea')
        expect(page).not_to have_content(answer.body)
      end
    end
    
    scenario 'author updates his answer with invalid answer', js: true do
      log_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      fill_in 'Edit your answer', with: 'Bo', match: :first
      click_on 'Save'
      
      within 'div#errors' do
        expect(page).to have_content('Body is too short') 
      end 
      within '.answers' do
        expect(page).to have_selector('textarea#answer_body')
        expect(page).to have_content(answer.body)
      end
    end
    
    scenario 'only author sees edit link' do
      log_in ( FactoryGirl.create(:user) )
      visit question_path(question)
      
      expect(page).not_to have_content('Edit answer')
    end
    
  end
  
  scenario 'unauthenticated user cannot see edit link' do
    visit question_path(question)
    
    expect(page).not_to have_content('Edit answer')
  end
  
end
