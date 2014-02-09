# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    description "An Activity"
    date_from "2014-01-29"
    time_from "06:20"
    time_to "17:40"
    after(:build) do |cl|
     	cl.courts << FactoryGirl.build_list(:court, 4)
    end

    factory :closure, :parent => :activity, :class => 'Closure' do
      date_to "2014-01-30"
    end

    factory :event, :parent => :activity, :class => 'Event' do
    end
  end
end
