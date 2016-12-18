# Preview all emails at http://localhost:3000/rails/mailers/answer_mailer
class AnswerMailerPreview < ActionMailer::Preview
  def test_preview
    AnswerMailer.answer_update(User.find(2), Answer.find(2))
  end
end
