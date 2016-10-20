require 'rails_helper'

feature 'delete question', %q{
  only author can delete his question
} do
  let(:delete_action) do
    visit question_path(@question)
    click_on('Delete question')
  end
  before { @question = FactoryGirl.create(:question) }  
  
  scenario 'author deletes his question' do
    @user = @question.user
    log_in(@user)
  
    expect { delete_action }.to change(Question, :count).by(-1)
    expect(page).to have_content('Question deleted')
  end
  
  scenario 'only author can see delete button' do
    @user = FactoryGirl.create(:user)
    log_in(@user)
    visit question_path(@question)
    
    expect(page).not_to have_content('Delete question')    
  end
  
end
