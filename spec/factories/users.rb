FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    email
    name 'John Snow'
    password '12345678'
    password_confirmation '12345678'
  end
  
  factory :invalid_user, class: User do
    email "foo@bar"
    name "fo"
    password "123"
    password_confirmation "123"
  end
  
end
