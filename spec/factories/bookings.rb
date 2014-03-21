# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking do
    user_id 1
    court_id 1
    date_from_text nil
    opponent_id nil
    date_from (Date.today+2)
    time_from "19:00"
    time_to "19:40"
    user
    court
    association :opponent, factory: :user, strategy: :build
  end
end
