FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :user do
    email 'lana@example.com'
    password 'password1234'
    password_confirmation 'password1234'

    trait :confirmed do
      confirmed true
    end
  end
end
