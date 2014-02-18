if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)

  AppSettings.setup do |config|

  	config.add_default :days_bookings_can_be_made_in_advance, 21
		config.add_default :max_peak_hours_bookings_weekly, 3
		config.add_default :max_peak_hours_bookings_daily, 1
		config.add_default :slot_time, 40
		config.add_default :slot_first, Time.parse("06:20")
		config.add_default :slot_last, Time.parse("22:20")
		config.add_default :slots, Slots::Base.new({slot_first: "06:20", slot_last: "22:20", slot_time: 40})
  end

  AppSettings.load!

  unless Rails.env == "test"
  	Slots::Constraints.setup do |config|
  		config.slot_first 	= Settings.slot_first
  		config.slot_last 		= Settings.slot_last
  		config.slot_time 		= Settings.slot_time
  	end

  	Settings.slots = Slots::Base.new
  end

end