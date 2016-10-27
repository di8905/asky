class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :body, presence: true, length: { minimum: 3 }
  scope :best_first, -> { order('best DESC NULLS LAST, created_at') }

  def best?
    !!best
  end
  
  def set_best
    question.answers.where(best: true).each do |answer|
      answer.update!(best: false)
    end
    update!(best: true)
  end
end
