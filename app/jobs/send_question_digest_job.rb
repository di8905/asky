class SendQuestionDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each.each do |user|
      DailyQuestionsDigestMailer.questions_digest(user).deliver_later
    end
  end
end
