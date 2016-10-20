require 'rails_helper'

feature 'list questions', %q{
  One can view list of questions. 
  No matter logged in or not.
} do
  given(:user) { FactoryGirl.create(:user) }
  before do 
    (1..3).each { |i| FactoryGirl.create(:question, title: "Title number: #{i}") }
  end
  
  scenario 'logged in user view list of questions' do
    log_in(user)
    visit questions_path

    (1..3).each { |i| expect(page).to have_content("Title number: #{i}")}
  end
  
  scenario 'not logged in user (guest) view list of questions' do
    visit questions_path
    
    (1..3).each { |i| expect(page).to have_content("Title number: #{i}")}
  end
  
end

feature 'view question with answers', %q{
  One can view the question with answers.
  No matter logged in or not.
} do
  given(:user) { FactoryGirl.create(:user) }
  given(:answer) { FactoryGirl.create(:answer) }
  
  scenario 'logged in user views the question' do
    log_in(user)
    visit question_path(answer.question)
    
    expect(page).to have_content('MyText must be at least 10 letters')
    expect(page).to have_content('My Title')
    expect(current_path).to eq question_path(answer.question)
    expect(page).to have_content('My answer text')
  end
  
  scenario 'not logged in user views the question' do
    visit question_path(answer.question)
    
    expect(page).to have_content('MyText must be at least 10 letters')
    expect(page).to have_content('My Title')
    expect(current_path).to eq question_path(answer.question)
    expect(page).to have_content('My answer text')
  end
end
