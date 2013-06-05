# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :court do
    sequence(:number, 1) {|n| n}
  end
end
