# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    description "An Activity"
    date_from Date.today
    time_from "06:20"
    time_to "17:40"
    after(:build) do |cl|
      if cl.courts.empty?
        cl.courts << FactoryGirl.build_list(:court, 2)
      end
    end

    factory :closure, :parent => :activity, :class => 'Closure' do
      date_to Date.today
      description "A Closure"
    end

    factory :event, :parent => :activity, :class => 'Event' do
      description "An Event"
    end
  end
end
