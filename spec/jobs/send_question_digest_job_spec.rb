require 'rails_helper'

RSpec.describe SendQuestionDigestJob, type: :job do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    allow(DailyQuestionsDigestMailer).to receive(:questions_digest).and_call_original
  end

  it 'sends daily digest to each user' do
    SendQuestionDigestJob.perform_now
    User.find_each.each { |user| expect(DailyQuestionsDigestMailer).to have_received(:questions_digest).with(user) }
  end
end
