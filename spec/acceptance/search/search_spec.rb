require_relative '../acceptance_helper_overrides'
require_relative '../search_helper_overrides'


feature 'Search', %q{
  To be able to find information, anyone can use search
} do
  
  let!(:question1) { FactoryGirl.create(:question, title: 'Yep, im found! Im searchable')}
  let!(:question2) { FactoryGirl.create(:question, title: 'qwertyuiop')}
  let!(:answer) { FactoryGirl.create(:answer, body: 'qwertyuiop')}
  let!(:comment) { FactoryGirl.create(:question_comment, body: 'qwertyuiop')}
  let!(:comment) { FactoryGirl.create(:answer_comment, body: 'qwertyuiop')}
  let!(:user) { FactoryGirl.create(:user, name: 'qwertyuiop')}
  let!(:not_findable) { FactoryGirl.create(:question, title: 'Imustnotbefound')}
  
  before do
    index
    visit search_path
  end
    
  scenario 'empty query', js: true do
    fill_in 'Search', with: 'searchable'
    click_button 'Search'
    
    expect(page).to have_content('Yep, im found! Im searchable')
    expect(page).not_to have_content('Imustnotbefound')
  end
  
  context 'without context given', js: true do
    scenario 'it searches all types of items' do
      fill_in 'Search', with: 'qwertyuiop'
      click_button 'Search'
      
      expect(page).to have_content('Question: qwertyuiop')
      expect(page).to have_content('Answer: qwertyuiop')
      expect(page).to have_content('Comment: qwertyuiop')
      expect(page).to have_content('User: qwertyuiop')
      expect(page).not_to have_content('Imustnotbefound')
    end
  end
  
  scenario 'questions search', js: true do
    fill_in 'Search', with: 'qwertyuiop'
    select 'Questions', from: 'context'
    click_button 'Search'
    
    expect(page).to have_content('Question: qwertyuiop')
    expect(page).not_to have_content('Answer: qwertyuiop')
    expect(page).not_to have_content('Comment: qwertyuiop')
    expect(page).not_to have_content('User: qwertyuiop')
    expect(page).not_to have_content('Imustnotbefound')
  end
  
  scenario 'answers search', js: true do
    fill_in 'Search', with: 'qwertyuiop'
    select 'Answers', from: 'context'
    click_button 'Search'
    
    expect(page).not_to have_content('Question: qwertyuiop')
    expect(page).to have_content('Answer: qwertyuiop')
    expect(page).not_to have_content('Comment: qwertyuiop')
    expect(page).not_to have_content('User: qwertyuiop')
    expect(page).not_to have_content('Imustnotbefound')
  end
  
  scenario 'comments search', js: true do
    fill_in 'Search', with: 'qwertyuiop'
    select 'Comments', from: 'context'
    click_button 'Search'
    
    expect(page).not_to have_content('Question: qwertyuiop')
    expect(page).not_to have_content('Answer: qwertyuiop')
    expect(page).to have_content('Comment: qwertyuiop')
    expect(page).not_to have_content('User: qwertyuiop')
    expect(page).not_to have_content('Imustnotbefound')
  end
  
  scenario 'users search', js: true do
    fill_in 'Search', with: 'qwertyuiop'
    select 'Users', from: 'context'
    click_button 'Search'
    
    expect(page).not_to have_content('Question: qwertyuiop')
    expect(page).not_to have_content('Answer: qwertyuiop')
    expect(page).not_to have_content('Comment: qwertyuiop')
    expect(page).to have_content('User: qwertyuiop')
    expect(page).not_to have_content('Imustnotbefound')
  end
  
  scenario 'multiple selection', js: true do
    fill_in 'Search', with: 'qwertyuiop'
    select 'Users', from: 'context'
    select 'Questions', from: 'context'
    click_button 'Search'
    
    expect(page).to have_content('Question: qwertyuiop')
    expect(page).not_to have_content('Answer: qwertyuiop')
    expect(page).not_to have_content('Comment: qwertyuiop')
    expect(page).to have_content('User: qwertyuiop')
    expect(page).not_to have_content('Imustnotbefound')
  end
    
    
end
