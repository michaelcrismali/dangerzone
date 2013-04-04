# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    email "lana@example.com"
    password "stirfriday"
    password_confirmation "stirfriday"
  end

end
