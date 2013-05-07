# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking do
    user_id 1
    court_number 1
    booking_datetime (DateTime.now+1)
    opponent_user_id 1
  end
end
