# frozen_string_literal: true
require 'rails_helper'

describe DailyQuestionsDigestMailer do
  describe "#questions_digest" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:questions) { FactoryGirl.create_list(:question, 3) }
    let(:mail) { DailyQuestionsDigestMailer.questions_digest(user) }

    it "sends questions digest" do
      expect(mail.to).to eq([user.email])
      expect(mail.body.encoded)
        .to match("The today's question titles list you can see below")
    end
  end
end