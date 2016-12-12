class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :rating
  has_many :answers, each_serializer: AnswerListSerializer
  has_many :comments
  has_many :attachments
end
