class DailyQuestionsDigestMailer < ApplicationMailer
  default from: 'di8905@yandex.ru'
  
  def questions_digest(user)
    @questions = Question.where(created_at: Date.yesterday.beginning_of_day..Date.today.end_of_day)
    mail to: user.email, subject: "Questions created at #{Date.today.strftime('%d %b %Y')} digest"
  end
end
