# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "username#{n}" }
    password 'password'
    email { "#{username}@example.com" }
    
    factory :user_with_booking do
      after(:build) do |booking|
        build(:booking)
      end
    end
  end
end
