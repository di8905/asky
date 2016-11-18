require_relative '../acceptance_helper_overrides'

feature 'vote for answer', %q{
  Logged user can give his vote for answer
  for better question assessment and rating
} do

  given(:answer) { FactoryGirl.create(:answer) }
  given(:user) { FactoryGirl.create(:user) }

  context 'logged in user' do
    before do
      log_in user
      visit question_path(answer.question)
    end
  
    scenario 'user rates the answer with like', js: true do
      within("#answer-1") do
        click_on('+')
  
        expect(page).to have_content('1')
      end
    end
    
    scenario 'user rates the answer with dislike', js: true do
      within("#answer-1") do
        click_on('-')
  
        expect(page).to have_content('-1')
      end
    end
    
    scenario 'user tries to vote twice', js: true do
      within("#answer-1") do
        click_on('+')
        sleep(1)
        click_on('+')
      
        within('.answer-rating') { expect(page).to have_content('1') }
      end
      
      expect(page).to have_content('Already voted this!')
    end
    
    scenario 'user can revoke his decision and re-vote', js: true do
      within("#answer-1") do
        click_on('+')
        sleep(1)
        click_on('-')
      
        within('.answer-rating') { expect(page).to have_content('0') }
      end
    end
  end  
  
  scenario 'user cannot vote own answer', js: true do
    log_in answer.user 
    visit question_path(answer.question)
    within("#answer-1") do 
      click_on('+') 
      
      expect(page).to have_content('0')
    end
    expect(page).to have_content("Can't vote your own!")
  end
  
  context 'not logged in user' do
    scenario 'not logged in user cannot see vote buttons' do
      visit question_path(answer.question)
      
      within('.question-rating') do
        expect(page).not_to have_content('+')
        expect(page).not_to have_content('-')
      end
    end
    
    scenario 'anybody can see question rating' do
      visit question_path(answer.question)


      within('#answer-1') do
        expect(page).to have_content('0')
      end
    end
  end
end
