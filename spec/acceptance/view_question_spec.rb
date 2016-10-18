require 'rails_helper'

feature 'list questions', %q{
  One can view list of questions. 
  No matter logged in or not.
} do
  let(:user) { FactoryGirl.create(:user) }
  before { FactoryGirl.create_list(:question, 3) }
  scenario 'logged in user view list of questions' do
    log_in(user)
    visit questions_path

    expect(page).to have_content("MyText must be at least 10 letters")
    (1..3).each { |i| expect(page).to have_content("Title number: #{i}")}
  end
  
  scenario 'not logged in user (guest) view list of questions' do
    visit questions_path
    expect(page).to have_content("MyText must be at least 10 letters")
    (4..6).each { |i| expect(page).to have_content("Title number: #{i}")}
  end
  
end

feature 'view question with answers', %q{
  One can view the question with answers.
  No matter logged in or not.
} do
  scenario 'logged in user views the question' 
  scenario 'not logged in user views the question'
end
