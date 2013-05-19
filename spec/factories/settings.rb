# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    name "my_setting"
    value "my value"
    description "my description"
    
    factory :days_that_can_be_booked_in_advance do
      name "days_that_can_be_booked_in_advance"
      value "21"
      description "Number of days that courts can be booked in advance"
    end
    
    factory :max_peak_hours_bookings do
      name "max_peak_hours_bookings"
      value "3"
      description "Maximum number of bookings that can be made during peak hours"
    end
    
    factory :peak_hours_start_time do
      name "peak_hours_start_time"
      value "17:40"
      description "Start time of peak hours"
    end
    
    factory :peak_hours_finish_time do
      name "peak_hours_finish_time"
      value "19:40"
      description "Finish time of peak hours"
    end
    
  end
  
end
