FactoryGirl.define do
  sequence(:title) {|i| "Title number: #{i}"}
    
  factory :question do
    user
    title
    body 'MyText must be at least 10 letters'
  end
  
  factory :question_with_answers, class: Question do
    user
    title
    body 'MyText must be at least 10 letters'
    after(:create) do |question|
      create_list(:answer, 5, question: question)
    end
  end

  factory :invalid_question, class: Question do
    title 'Te'
    body 'Least 10'
  end
end
