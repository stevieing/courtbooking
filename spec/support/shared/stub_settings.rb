module StubSettings

	def options
		{slot_first: "06:20", slot_last: "22:20", slot_time: 40}
	end

	def stub_settings
    create_settings_constant
		AppSettings.const.stub(:days_bookings_can_be_made_in_advance).and_return(21)
    AppSettings.const.stub(:max_peak_hours_bookings_weekly).and_return(3)
    AppSettings.const.stub(:max_peak_hours_bookings_daily).and_return(1)
    AppSettings.const.stub(:slot_time).and_return(40)
    AppSettings.const.stub(:slot_first).and_return(Time.parse(options[:slot_first]))
    AppSettings.const.stub(:slot_last).and_return(Time.parse(options[:slot_last]))
    AppSettings.const.stub(:slots).and_return(CourtSlots.new(options))
	end

  def create_settings_constant
    Kernel.const_set(AppSettings.const_name, OpenStruct.new) unless Kernel.const_defined?(AppSettings.const_name)
  end

end