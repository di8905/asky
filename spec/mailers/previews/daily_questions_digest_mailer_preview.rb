# Preview all emails at http://localhost:3000/rails/mailers/daily_questions_digest_mailer
class DailyQuestionsDigestMailerPreview < ActionMailer::Preview
  def test_preview
    DailyQuestionsDigestMailer.questions_digest(User.find(4))
  end
end
