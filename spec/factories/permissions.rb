# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    allowed_action_id 1
    user_id 1
    user
  end

end
