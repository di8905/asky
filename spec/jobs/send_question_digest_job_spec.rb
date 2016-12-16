require 'rails_helper'

RSpec.describe SendQuestionDigestJob, type: :job do
  it 'sends daily digest' do
      expect(User).to receive(:send_daily_digest)
    SendQuestionDigestJob.perform_now
  end
end
