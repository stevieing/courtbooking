# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :court_time do
    court_id 1
    day 1
    from "06:20"
    to "22:00"
    court
    
    factory :opening_time, :parent => :court_time, :class => 'OpeningTime' do
      from "06:20"
      to "22:00"
    end
    
    factory :peak_time, :parent => :court_time, :class => 'PeakTime' do
      from "17:40"
      to "20:20"
    end
  end
end
