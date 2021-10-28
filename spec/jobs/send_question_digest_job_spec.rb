require 'rails_helper'

RSpec.describe SendQuestionDigestJob, type: :job do
  let!(:user) { FactoryGirl.create(:user) }

  it 'sends daily digest to each user' do
    User.find_each.each { |user| expect(DailyQuestionsDigestMailer).to receive(:questions_digest).with(user).and_call_original }
    SendQuestionDigestJob.perform_now
  end
end
