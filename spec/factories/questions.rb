FactoryGirl.define do
  sequence(:title, 1) do |n|
    "Title number: #{n}"
  end
  factory :question do
    title 
    body 'MyText must be at least 10 letters'
  end

  factory :invalid_question, class: Question do
    title 'Te'
    body 'Least 10'
  end
end
