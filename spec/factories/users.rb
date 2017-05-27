FactoryGirl.define do
  factory :user do
    nickname "mynameisjonas"
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    password "secretPassword"
    password_confirmation "secretPassword"
  end
end
