FactoryGirl.define do
  # sequence (:body) { |i| "Test comment text number #{i}" }
  
  factory :question_comment, class: Comment do
    user
    association :commentable, factory: :question
    body
  end
  
  factory :answer_comment, class: Comment do
    user
    association :commentable, factory: :answer
    body
  end
  
end
