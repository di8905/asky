class SendAnswerNewsletterJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each.each do |user|
      AnswerMailer.answer_update(user, answer).deliver_later
    end
  end
end
