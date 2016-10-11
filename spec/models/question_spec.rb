require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates presence of title' do
    expect(Question.new(body: 'Test... Test...')).to_not be_valid
  end
end
