class AnswerMailer < ApplicationMailer
  default from: 'di8905@yandex.ru'
  
  def answer_update(user, answer)
    @answer = answer
    mail to: user.email, subject: "The question you subscribed has new answer."
  end
end
