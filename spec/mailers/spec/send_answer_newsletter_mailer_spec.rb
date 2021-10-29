# frozen_string_literal: true

require 'rails_helper'

describe AnswerMailer do
  describe "#answer_update" do
    let(:user) { FactoryGirl.create(:user) }
    let(:answer) { FactoryGirl.create(:answer) }
    let(:mail) { AnswerMailer.answer_update(user, answer) }

    it "sends email" do
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq("The question you subscribed has new answer.")
      expect(mail.body.encoded).to match("The question updated with answer")
    end
  end
end