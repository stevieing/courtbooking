#require 'slots/cell_slot'

DependentLoader.start(:settings) do |on|

    on.success do

      NumberSetting.create(
        name: "days_bookings_can_be_made_in_advance",
        value: "21",
        description: "Number of days that courts can be booked in advance"
      )

      NumberSetting.create(
        name: "max_peak_hours_bookings_weekly",
        value: "3",
        description: "Maximum number of bookings that can be made during peak hours for the week"
      )

      NumberSetting.create(
        name: "max_peak_hours_bookings_daily",
        value: "1",
        description: "Maximum number of bookings that can be made during peak hours for the day"
      )

      NumberSetting.create(
        name: "slot_time",
        value: "40",
        description: "Slot time"
      )

      TimeSetting.create(
        name: "slot_first",
        value: "06:20",
        description: "First slot"
      )

      TimeSetting.create(
        name: "slot_last",
        value: "22:20",
        description: "Last slot"
      )

      AppSetup.load_constants!

    end

    on.failure do

      AppSetup.load_constants!

    end

end