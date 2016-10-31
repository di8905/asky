class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 3 }
  scope :best_first, -> { order('best DESC') }
  
  accepts_nested_attributes_for :attachments
    
  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
