module StubSettings

	def options
		{slot_first: "06:20", slot_last: "22:20", slot_time: 40}
	end

	def stub_settings
		Settings.stub(:days_bookings_can_be_made_in_advance).and_return(21)
    Settings.stub(:max_peak_hours_bookings_weekly).and_return(3)
    Settings.stub(:max_peak_hours_bookings_daily).and_return(1)
    Settings.stub(:slot_time).and_return(40)
    Settings.stub(:slot_first).and_return(Time.parse(options[:slot_first]))
    Settings.stub(:slot_last).and_return(Time.parse(options[:slot_last]))
    Settings.stub(:slots).and_return(CourtSlots.new(options))
	end

end