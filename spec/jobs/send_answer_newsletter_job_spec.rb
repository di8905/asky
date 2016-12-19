require 'rails_helper'

RSpec.describe SendAnswerNewsletterJob, type: :job do
  let(:question) { FactoryGirl.create(:question) }
  let(:answer) { FactoryGirl.create(:answer, question: question) }
  let(:users) { FactoryGirl.create_list(:user, 3) }
  before do
    question.subscribers << users
  end
  
  it 'should mail answer to users' do
    question.subscribers.find_each.each do |user|
      expect(AnswerMailer).to receive(:answer_update).with(user, answer).and_call_original
    end
    
    SendAnswerNewsletterJob.new.perform(answer)
  end
end
