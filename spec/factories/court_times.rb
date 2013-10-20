# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :court_time do
    court_id 1
    day 1
    time_from "06:20"
    time_to "22:00"
    court
    
    factory :opening_time, :parent => :court_time, :class => 'OpeningTime' do
      time_from "06:20"
      time_to "22:20"
    end
    
    factory :peak_time, :parent => :court_time, :class => 'PeakTime' do
      time_from "17:40"
      time_to "20:20"
    end
  end
end
