require_relative '../acceptance_helper_overrides'

feature 'vote for question', %q{
  Logged user can give his vote for question
  for better question assessment and rating
} do

  given(:question) { FactoryGirl.create(:question) }
  given(:user) { FactoryGirl.create(:user) }

  scenario 'anybody can see question rating' do
    visit question_path(question)
    
    within('.question-rating') do
      expect(page).to have_content('0')
    end
  end
  
  scenario 'logged in user rates the question with like', js: true do
    log_in user
    visit question_path(question)
    within('.question-rating') do
      click_on('+')
    end
    
    within('.question-rating') do
      expect(page).to have_content('1')
    end
  end
  
  scenario 'logged in user rates the question with dislike', js: true do
    log_in user
    visit question_path(question)
    within('.question-rating') do
      click_on('-')
    end
    
    within('.question-rating') do
      expect(page).to have_content('-1')
    end
  end
  
  scenario 'user tries to vote twice' do
    log_in user
    visit question_path(question)
    within('.question-rating') do
      click_on('+')
      click_on('+')
    end
    
        
  end
  
  scenario 'not logged in user cannot see vote buttons'
  scenario 'one user cannot rate one question twice or more'
  scenario 'user can revoke his decision and re-vote'
end
