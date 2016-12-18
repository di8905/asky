require_relative '../acceptance_helper_overrides'

feature 'subscribe question updates', %q{
  Logged user can subscribe for question updates
} do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }
  
  context 'subscribed user' do
    before do
      question.subscribe(user)
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
      question.unsubscribe(user)
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
