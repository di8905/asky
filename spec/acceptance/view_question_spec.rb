require 'rails_helper'

feature 'list questions', %q{
  One can view list of questions. 
  No matter logged in or not.
} do
  given(:user) { FactoryGirl.create(:user) }
  given(:check_expectations) do
    (1..3).each { |i| expect(page).to have_content("Title number: #{i}")}
  end
  before do 
    (1..3).each { |i| FactoryGirl.create(:question, title: "Title number: #{i}") }
  end
  
  scenario 'logged in user view list of questions' do
    log_in(user)
    visit questions_path

    check_expectations
  end
  
  scenario 'not logged in user (guest) view list of questions' do
    visit questions_path
    
    check_expectations
  end
  
end

feature 'view question with answers', %q{
  One can view the question with answers.
  No matter logged in or not.
} do
  given(:user) { FactoryGirl.create(:user) }
  given(:question) { FactoryGirl.create(:question) }
  given(:check_expectations) do 
    expect(page).to have_content('MyText must be at least 10 letters')
    expect(page).to have_content('My Title')
    expect(current_path).to eq question_path(question)
    expect(page).to have_content('My answer text')
  end
  
  scenario 'logged in user views the question' do
    log_in(user)
    visit question_path(question)
    FactoryGirl.create(:answer, question: question)
    
    save_and_open_page
    check_expectations
  end
  
  scenario 'not logged in user views the question' do
    visit question_path(question)
    
    check_expectations
  end
end
