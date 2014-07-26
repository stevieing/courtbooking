module StubSettings
  def options
    {slot_first: "06:20", slot_last: "22:20", slot_time: 40}
  end

  def stub_settings
    create_settings_constant
    AppSettings.const.stubs(:days_bookings_can_be_made_in_advance).returns(21)
    AppSettings.const.stubs(:max_peak_hours_bookings_weekly).returns(3)
    AppSettings.const.stubs(:max_peak_hours_bookings_daily).returns(1)
    AppSettings.const.stubs(:slot_time).returns(40)
    AppSettings.const.stubs(:slot_first).returns(Time.parse(options[:slot_first]))
    AppSettings.const.stubs(:slot_last).returns(Time.parse(options[:slot_last]))
    AppSettings.const.stubs(:slots).returns(CourtSlots.new(options))
  end

  def create_settings_constant
    Kernel.const_set(AppSettings.const_name, OpenStruct.new) unless Kernel.const_defined?(AppSettings.const_name)
  end
end
