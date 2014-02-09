if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)

  AppSettings.setup do |config|
  	config.add_dependency :slots, :courts_opening_time, :courts_closing_time, :slot_time

  	config.add_default :days_bookings_can_be_made_in_advance, 21
		config.add_default :max_peak_hours_bookings_weekly, 3
		config.add_default :max_peak_hours_bookings_daily, 1
		config.add_default :slot_time, 40
		config.add_default :courts_opening_time, Time.parse("06:20")
		config.add_default :courts_closing_time, Time.parse("22:20")
		config.add_default :slots, Slots.new({:courts_opening_time => Time.parse("06:20"), :courts_closing_time =>Time.parse("22:20"), :slot_time => 40})
  end

  AppSettings.load!
end