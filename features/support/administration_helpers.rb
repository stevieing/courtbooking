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

  def add_court_time(n, type, time_from, time_to)
    (1..n.to_i).each do |i|
      click_link "Add #{type.capitalize} Time"
      fill_in_court_time "#{type}_time_#{i}", Date.days_of_week.keys.first, time_from, time_to
    end  
  end

  def fill_in_court_time(id, day, time_from, time_to)
    within("##{id}") do
      select day, from: "Day"
      select time_from, from: "From"
      select time_to, from: "To"
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

  def add_user_permissions
    AllowedAction.all.each_with_index do |permission, i|
      click_link "Add permissions"
      within("#permission_#{i+1}") do
        select permission.name, from: "Permission"
      end
    end
  end

  def user_should_have_standard_permissions(email_address)
    User.find_by(:email => email_address).permissions.count.should == AllowedAction.all.count
  end


end

World(AdministrationHelpers)