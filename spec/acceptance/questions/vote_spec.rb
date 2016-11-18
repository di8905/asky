require_relative '../acceptance_helper_overrides'

feature 'vote for question', %q{
  Logged user can give his vote for question
  for better question assessment and rating
} do

  given(:question) { FactoryGirl.create(:question) }
  given(:user) { FactoryGirl.create(:user) }

  context 'logged in user' do
  before do
    log_in user
    visit question_path(question)
  end
  
    scenario 'user rates the question with like', js: true do
      within('.question-rating') do
        click_on('+')
      end
      
      within('.question-rating') do
        expect(page).to have_content('1')
      end
    end
    
    scenario 'user rates the question with dislike', js: true do
      within('.question-rating') do
        click_on('-')
      end
      
      within('.question-rating') do
        expect(page).to have_content('-1')
      end
    end
    
    scenario 'user tries to vote twice', js: true do
      within('.question-rating') do
        click_on('+')
        click_on('+')
      end

      within('.question-rating') { expect(page).to have_content('1') }
    end
    
    scenario 'user can revoke his decision and re-vote', js: true do
      within('.question-rating') do
        click_on('+')
        click_on('-')
      end
      
      within('.question-rating') { expect(page).to have_content('0') }
    end
  end  
  
  context 'not logged in user' do
    scenario 'not logged in user cannot see vote buttons' do
      visit question_path(question)
      
      within('.question-rating') do
        expect(page).not_to have_content('+')
        expect(page).not_to have_content('-')
      end
    end
    
    scenario 'anybody can see question rating' do
      visit question_path(question)
      
      within('.question-rating') do
        expect(page).to have_content('0')
      end
    end
  end
end
