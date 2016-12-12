class SingleAnswerSerializer < AnswerListSerializer
  has_many :comments
  has_many :attachments
end
