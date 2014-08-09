# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :test_model do
    attr_a "MyString"
    attr_b "MyString"
    attr_c 1
  end
end
