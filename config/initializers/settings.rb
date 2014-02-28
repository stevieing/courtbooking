if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)

	AppSettings.load!

  unless Rails.env.test?
  	
  	Slots::Constraints.setup do |config|
  		config.slot_first 	= Settings.slot_first
  		config.slot_last 		= Settings.slot_last
  		config.slot_time 		= Settings.slot_time
  	end

  	AppSettings.const_name.constantize.slots = CourtSlots.new
  end

end