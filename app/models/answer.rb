class Answer < ActiveRecord::Base
  include Voteable
  belongs_to :user
  belongs_to :question, touch: true
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 3 }
  validates :question_id, :user_id, presence: true
  default_scope { order('best DESC, created_at') }
    
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  after_create { SendAnswerNewsletterJob.perform_later(self) }
  
    
  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
