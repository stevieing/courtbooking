# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
  end
  
  factory :action_permission do
    controller "mains"
    actions "new"
  end
  
  factory :param_permission do
    resource "main"
    attrs "first"
  end
end
