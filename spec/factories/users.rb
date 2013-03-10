# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username 'username'
    password 'password'
    email 'user@company.co.uk'
  end
end
