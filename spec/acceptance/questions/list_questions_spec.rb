require_relative '../acceptance_helper_overrides'

feature 'list questions', %q{
  One can view list of questions. 
  No matter logged in or not.
} do
  given(:user) { FactoryGirl.create(:user) }
  before { @questions = FactoryGirl.create_list(:question, 3) }
  
  scenario 'logged in user view list of questions' do
    log_in(user)
    visit questions_path

    @questions.each { |question| expect(page).to have_content(question.title) }
  end
  
  scenario 'not logged in user (guest) view list of questions' do
    visit questions_path
    
    @questions.each { |question| expect(page).to have_content(question.title)}
  end
end
