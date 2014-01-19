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

  def add_valid_court_time(n, type)
    fill_in_court_time "#{type}_time_#{n}", Date.days_of_week["Monday"], build("#{type}_time".to_sym)
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
  
  def valid_user_details
    user = build(:user)
    {username: user.username, email: user.email, password: user.password, password_confirmation: user.password}
  end

  def has_multiple_court_times(court_number, number, object)
    court = Court.find_by :number => court_number
    court.send(object).count.should ==  number.to_i
  end

  def remove_court_time(n, type)
    within("##{type}_time_#{n}") do
      click_link "Remove"
    end
  end

end

World(AdministrationHelpers)