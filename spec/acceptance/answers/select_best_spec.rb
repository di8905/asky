require_relative '../acceptance_helper'

feature 'select best answer', %q{
  To improve answer quality, author of question can select one answer as best.
} do
  
  context 'author' do
    given(:question) { FactoryGirl.create(:question_with_answers) }
    given(:user) { question.user }
    
    scenario 'of question selects one of answers as best' do
      log_in user
      visit question_path(question)
      
    end
    
    scenario 'changes his decision about best answer'
  end
  
  context 'not author' do
    scenario 'non-author cannot see select as best button'
    scenario 'unauthenticated user cannot see select as best button'
  end
    
end
