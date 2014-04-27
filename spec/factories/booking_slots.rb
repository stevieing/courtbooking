FactoryGirl.define do

  factory :properties, class: BookingSlots::Properties do

    date Date.today
    user { FactoryGirl.create(:member) }

    initialize_with { new(date, user)}
  end

  factory :records, class: BookingSlots::Records do
    properties { FactoryGirl.build(:properties) }

    initialize_with { new(properties) }
  end

  factory :todays_slots, class: BookingSlots::TodaysSlots do
    slots { FactoryGirl.build(:court_slots) }
    records { FactoryGirl.build(:records) }

    initialize_with { new(slots, records) }
  end

  factory :bookings, class: BookingSlots::Bookings do
    properties { FactoryGirl.build(:properties)}

    initialize_with { new(properties)}
  end

  factory :activities, class: BookingSlots::Activities do
    properties { FactoryGirl.build(:properties)}

    initialize_with { new(properties)}
  end

  factory :unavailable, class: BookingSlots::Unavailable do
    properties { FactoryGirl.build(:properties)}

    initialize_with { new(properties)}
  end

  factory :courts, class: BookingSlots::Courts do
    properties { FactoryGirl.build(:properties)}

    initialize_with { new(properties)}
  end

  # factory :current_record, class: BookingSlots::CurrentRecord do
  #   text "a record"
  #   span 4
  #   link '/a/dodgy/link'
  #   klass 'seriousclass'
  # end

  factory :cell, class: BookingSlots::Cell::Base do
  end

  factory :dates, class: BookingSlots::Dates do
    date_from Date.today
    current_date Date.today
    no_of_days 21
    split 7

    initialize_with { new(date_from, current_date, no_of_days, split)}
  end

  factory :booking_slots_table, class: BookingSlots::Table do
    date Date.today
    user { FactoryGirl.build(:user)}
    slots { FactoryGirl.build(:court_slots) }

    initialize_with { new(date, user, slots)}
  end
end