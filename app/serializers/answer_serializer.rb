class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :rating, :created_at, :updated_at, :body, :question_id, :user_id, :best
  has_many :comments
end
