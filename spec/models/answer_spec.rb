require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(3) }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  describe 'set_best answer method tests' do
    let(:question) { FactoryGirl.create(:question_with_answers) }
    let(:answer1) { question.answers[1] }
    let(:answer2) { question.answers[2] }

    context 'best answer is not set' do
      it { expect(answer1.best?).to eq false }
      it { expect(answer2.best?).to eq false }
    end

    context 'best answer set' do
      before { answer1.set_best }
      
      it { expect(answer1.best?).to eq true }
      it { expect(answer2.best?).to eq false }
    end

    context 'best answer change' do
      before do
        answer1.set_best 
        answer2.set_best 
        answer1.reload
        answer2.reload
      end
      
      it { expect(answer1.best?).to eq false }
      it { expect(answer2.best?).to eq true }
    end
  end
end
