FactoryGirl.define do
  sequence(:body) {|i| "Test body number #{i} "}
  
  factory :answer do
    user
    question
    body 
  end
  
  factory :invalid_answer, class: Answer do
    user
    question
    body "T"
  end
end
