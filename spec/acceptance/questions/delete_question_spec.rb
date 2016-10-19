require 'rails_helper'

feature 'delete question', %q{
  only author can delete his question
} do
  let(:delete_action) do
    visit question_path(@question)
    click_on('Delete question')
  end
  
  scenario 'author deletes his question' do
    @question = FactoryGirl.create(:question)
    @user = @question.user
    log_in(@user)
  
    expect { delete_action }.to change(Question, :count).by(-1)
    expect(page).to have_content('Question deleted')
  end
  
  scenario 'user tries to delete question of another user' do
    @question = FactoryGirl.create(:question)
    @user = FactoryGirl.create(:user)
    log_in(@user)
    
    expect { delete_action }.not_to change(Question, :count)
    expect(page).to have_content("o access to delete this question")
  end
  
end
