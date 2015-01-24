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
    allow(AppSettings).to receive(:load!)
    allow(AppSettings.const).to receive(:days_bookings_can_be_made_in_advance).and_return(21)
    allow(AppSettings.const).to receive(:max_peak_hours_bookings_weekly).and_return(3)
    allow(AppSettings.const).to receive(:max_peak_hours_bookings_daily).and_return(1)
    allow(AppSettings.const).to receive(:slot_time).and_return(options[:slot_time])
    allow(AppSettings.const).to receive(:slot_first).and_return(options[:slot_first])
    allow(AppSettings.const).to receive(:slot_last).and_return(options[:slot_last])
    allow(AppSettings.const).to receive(:slots).and_return(Slots::Grid.new(options))

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