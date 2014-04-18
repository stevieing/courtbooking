# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "username#{n}" }
    full_name { "Full #{username}" }
    password 'password'
    email { "#{username}@example.com" }

    factory :member, class: "Member" do
    end

    factory :admin, class: "Admin" do
    end
  end
end
