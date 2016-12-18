require_relative '../acceptance_helper_overrides'

feature 'subscribe question updates', %q{
  Logged user can subscribe for question updates
} do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }
  before do
    question.subscribe(user)
    log_in user
    visit question_path(question)
  end
  
  scenario 'subscribed user cannot see subscribe link' do
    within('#question-buttons') do
      expect(page).to_not have_content('subscribe')
    end
  end
end
