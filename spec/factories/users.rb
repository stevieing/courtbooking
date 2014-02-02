# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "username#{n}" }
    full_name { "Full #{username}" }
    password 'password'
    email { "#{username}@example.com" }
  end
end
