module AdministrationHelpers
  
  def valid_setting_value(setting)
    case setting.type
    when "NumberSetting"
      "1"
    when "TimeSetting"
      "10:30"
    else
      setting.value
    end
  end
  
  def invalid_setting_value(setting)
    case setting.type
    when "NumberSetting"
      "10:30"
    when "TimeSetting"
      "1"
    else
      setting.value
    end
  end
  
  def valid_email
    build(:user).email
  end
  
  def invalid_email
    users.last.email
  end
  
  def fill_in_details(fields)
    fields.each do |field, value|
      fill_in field.to_s.capitalize.gsub('_',' '), with: value
    end
  end
  
  def add_valid_opening_time
    add_valid_court_time "openingtimes", build(:opening_time)
  end
  
  def add_valid_peak_time
    add_valid_court_time "peaktimes", build(:peak_time)
  end
  
  def add_valid_court_time(key, court_time)
    fill_in_court_time key, Date.days_of_week["Monday"], court_time
  end
  
  def fill_in_court_time(id, day, court_time)
    within("##{id}") do
      fill_in "Day", with: day
      fill_in "From", with: court_time.time_from
      fill_in "To", with: court_time.time_to
    end
  end
  
  def add_invalid_court_time(court_time)
    within("##{court_time}") do
      fill_in "From", with: "invalid value"
    end
  end
  
  def has_valid_court_times(court_number, object)
    court = Court.find_by :number => court_number
    court.send(object).should_not be_empty
  end
  
  def has_valid_peak_times(court_number)
    has_valid_court_times court_number, :peak_times
  end
  
  def has_valid_opening_times(court_number)
    has_valid_court_times court_number, :opening_times
  end
end

World(AdministrationHelpers)