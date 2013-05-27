# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking do
    user_id 1
    court_number 1
    playing_at (DateTime.now+1)
    playing_at_text nil
    opponent_user_id nil
  end
end
