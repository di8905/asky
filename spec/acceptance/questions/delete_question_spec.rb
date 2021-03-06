require_relative '../acceptance_helper_overrides'

feature 'delete question', %q{
  only author can delete his question
} do
  let(:delete_action) do
    visit question_path(@question)
    click_on('delete question')
    page.driver.accept_js_confirms!
  end
  before { @question = FactoryGirl.create(:question) }  
  
  context 'logged in user' do
    scenario 'author deletes his question', js: true do
      @user = @question.user
      log_in(@user)
      delete_action  
      
      expect(page).not_to have_content(@question.body)
      expect(page).to have_content('Question was successfully destroyed')
    end
    
    scenario 'only author can see delete button' do
      @user = FactoryGirl.create(:user)
      log_in(@user)
      visit question_path(@question)
      
      expect(page).not_to have_content('Delete question')    
    end
  end
  
  context 'not logged in user' do
    scenario 'not logged in user cannot see delete button' do
      @question = FactoryGirl.create(:question)
      visit question_path(@question)
      
      expect(page).not_to have_content('Delete question')
    end
  end
end
