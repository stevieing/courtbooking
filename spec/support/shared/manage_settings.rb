module ManageSettings

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
end