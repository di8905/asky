require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3) }
  
  before do 
    @question = FactoryGirl.create(:question)
    @another_question = FactoryGirl.create(:question)
    @user = @question.user  
  end
  
  it 'has appropriate author_of? method (true condition)' do
    expect(@user.author_of?(@question)).to eq true
  end  
  
  it 'has appropriate author_of? method (false condition)' do
    expect(@user.author_of?(@another_question)).to eq false
  end    
end
