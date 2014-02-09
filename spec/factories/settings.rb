# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    name "my_setting"
    value "my value"
    description "my description"
  end

  factory :number_setting, :class => "NumberSetting" do
    name "number_setting"
    value "1"
    description "number setting"

    factory :days_bookings_can_be_made_in_advance do
      name "days_bookings_can_be_made_in_advance"
      value "21"
      description "Number of days that courts can be booked in advance"
    end

    factory :max_peak_hours_bookings_weekly do
      name "max_peak_hours_bookings_weekly"
      value "3"
      description "Maximum number of bookings that can be made during peak hours in a single week"
    end

     factory :max_peak_hours_bookings_daily do
      name "max_peak_hours_bookings_daily"
      value "1"
      description "Maximum number of bookings that can be made during peak hours in a single day"
    end
    
    factory :slot_time do
      name "slot_time"
      value "40"
      description "Slot time"
    end
  end

  factory :time_setting, :class => "TimeSetting" do
    name "time_setting"
    value "10:30"
    description "time setting"

    factory :courts_opening_time, :class => "TimeSetting" do
      name "courts_opening_time"
      value "06:20"
      description "Court opening time"
    end

    factory :courts_closing_time, :class => "TimeSetting" do
      name "courts_closing_time"
      value "22:20"
      description "Court closing time"
    end
  end

end