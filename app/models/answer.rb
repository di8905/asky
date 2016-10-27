class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :body, presence: true, length: { minimum: 3 }
  scope :best_first, -> { order('best DESC NULLS LAST') }

  def best?
    !!best
  end
  
  def set_best
      question.answers.where(best: true).update_all(best: false)
      reload
      update!(best: true)
  end
end
