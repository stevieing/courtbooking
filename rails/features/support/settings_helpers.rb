module SettingsHelpers

  def create_setting(name)
    if Setting.find_by(:name => name).nil?
      if FactoryGirl.factories.map(&:name).include? name
        FactoryGirl.create(name)
      end
    end
  end

  def create_settings(*settings)
    settings.each do |setting|
      create_setting setting
    end
  end

  def create_standard_settings
    create_settings :days_bookings_can_be_made_in_advance, :max_peak_hours_bookings_weekly,
    :max_peak_hours_bookings_daily, :slot_time, :slot_first, :slot_last
  end

  def stub_settings
    create_settings_constant
    AppSettings.stub(:load!)
    AppSettings.const.stub(:days_bookings_can_be_made_in_advance).and_return(21)
    AppSettings.const.stub(:max_peak_hours_bookings_weekly).and_return(3)
    AppSettings.const.stub(:max_peak_hours_bookings_daily).and_return(1)
    AppSettings.const.stub(:slot_time).and_return(options[:slot_time])
    AppSettings.const.stub(:slot_first).and_return(Time.parse(options[:slot_first]))
    AppSettings.const.stub(:slot_last).and_return(Time.parse(options[:slot_last]))
    AppSettings.const.stub(:slots).and_return(Slots::Base.new(options))
  end

  def create_settings_constant
    Kernel.const_set(AppSettings.const_name, OpenStruct.new) unless Kernel.const_defined?(AppSettings.const_name)
  end

private

  def options
    {slot_first: "06:20", slot_last: "22:20", slot_time: 40, courts: Court.all}
  end

end

World(SettingsHelpers)