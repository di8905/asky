require_relative '../acceptance_helper'

feature 'select best answer', %q{
  To improve answer quality, author of question can select one answer as best.
} do
  
  given(:question) { FactoryGirl.create(:question_with_answers) }
  
  context 'author' do
    given(:user) { question.user }
    
    scenario 'of question selects one of answers as best', js: true do
      log_in user
      visit question_path(question)
      within('#answer-3') do
        click_link('select as best')
      end
      
      within('#answer-3') do
        expect(page).to have_content('span .glyphicon-ok')
      end
      
    end
    
    scenario 'changes his decision about best answer' do
      log_in user
      visit question_path(question)
      within('#answer-4') do
        click_link('select as best')
      end
      
      within('#answer-4') do
        expect(page).to have_content('span .glyphicon-ok')
      end
    end
  end
  
  context 'not author' do
    scenario 'non-author cannot see select as best button' do
      log_in ( FactoryGirl.create(:user))
      visit question_path(question)
      expect(page).not_to have_content('select as best')
    end
    
    scenario 'unauthenticated user cannot see select as best button' do
      visit question_path(question)
      expect(page).not_to have_content('select as best')
    end
  end
    
end
