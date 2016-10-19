FactoryGirl.define do
  factory :question do
    user
    title 'My Title'
    body 'MyText must be at least 10 letters'
  end

  factory :invalid_question, class: Question do
    title 'Te'
    body 'Least 10'
  end
end
