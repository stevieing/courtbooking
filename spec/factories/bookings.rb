# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking do
    user_id 1
    court_number 1
    playing_on_text nil
    opponent_id nil
    playing_on (Date.today+2)
    playing_from "19:00"
    playing_to "19:40"
    user
    association :opponent, factory: :user, strategy: :build
  end
end
