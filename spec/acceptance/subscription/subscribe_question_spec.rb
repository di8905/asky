require_relative '../acceptance_helper_overrides'

feature 'subscribe question updates', %q{
  Logged user can subscribe for question updates
} do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }
  
    
  context 'subscribed user' do
    before do
      FactoryGirl.create(:subscription, user_id: user.id, question_id: question.id)
      log_in user
      visit question_path(question)
    end
      
    scenario 'subscribed user sees unsubscribe link' do
      within('#question-buttons') do
        expect(page).to have_link('unsubscribe')
      end
    end
  end
  
  context 'unsubscribed' do
    before do
      log_in user
      visit question_path(question)
    end
    
    scenario 'unsubscribed user sees subscribe link' do
      within('#question-buttons') do
        expect(page).to have_link('subscribe')
      end
    end
  end
end
