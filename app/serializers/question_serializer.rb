class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :rating
  has_many :answers
  has_many :comments
end
