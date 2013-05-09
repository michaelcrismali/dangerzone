FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :user do
    email { generate :email }
    password 'password1234'
    password_confirmation { |u| u.password }

    trait :confirmed do
      confirmed true
    end
  end
end
