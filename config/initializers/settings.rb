if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)

  unless Rails.env.test?

    AppSettings.load!

  	Slots::Constraints.setup do |config|
  		config.slot_first 	= AppSettings.const.slot_first
  		config.slot_last 		= AppSettings.const.slot_last
  		config.slot_time 		= AppSettings.const.slot_time
  	end

  	AppSettings.const.slots = CourtSlots.new
  end

end