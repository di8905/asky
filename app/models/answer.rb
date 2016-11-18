class Answer < ActiveRecord::Base
  include Voteable
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 3 }
  scope :best_first, -> { order('best DESC') }
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
    
  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
