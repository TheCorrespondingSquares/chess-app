FactoryGirl.define do
  factory :user do
    nickname "mynameisjonas"
    email "user@email.com"
    password "secretPassword"
    password_confirmation "secretPassword"
  end
end
