require 'rails_helper'

RSpec.describe SendAnswerNewsletterJob, type: :job do
  let(:answer) { FactoryGirl.create(:answer) }
  before { answer.question.subscribe(answer.user) }
  
  it 'should mail answer to users' do
    expect(AnswerMailer).to receive(:answer_update).and_call_original
    
    SendAnswerNewsletterJob.new.perform(answer)
  end
end
