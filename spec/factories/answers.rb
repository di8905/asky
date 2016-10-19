FactoryGirl.define do
  factory :answer do
    user
    question
    body 'My answer text'
  end
end
