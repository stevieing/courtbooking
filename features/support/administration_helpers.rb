module AdministrationHelpers
  
  def valid_setting_value(setting)
    set_setting_value setting, "1", "10:30"
  end

  def invalid_setting_value(setting)
    set_setting_value setting, "10:30", "1"
  end

  def set_setting_value(setting, vala, valb)
    case setting.type
      when "NumberSetting" then vala
      when "TimeSetting" then valb
      else setting.value
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
    {username: user.username, full_name: user.full_name, email: user.email, password: user.password, password_confirmation: user.password}
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
        select permission.name
      end
    end
  end

  def user_should_have_standard_permissions(email_address)
    User.find_by(:email => email_address).permissions.count.should == AllowedAction.all.count
  end

  def add_valid_activity_details(activity)
    fill_in (activity.type == "Closure" ? "Reason" : "Description"), with: activity.description
    fill_in "Date from", with: activity.date_from
    fill_in "Date to", with: activity.date_to if activity.type == "Closure"
    select activity.time_from, from: "Time from"
    select activity.time_to, from: "Time to"
  end

  def valid_closure_details
    build(:closure)
  end

  def add_list_of_courts
    within("#courts") do
      courts.each do |court|
        check court.number
      end
    end
  end

  def remove_all_courts_from_activity(activity)
    activity.courts.each do |court|
      uncheck court.number
    end
  end

  def create_activity_and_count(activity)
    create_current_activity create(activity.to_sym)
    create_current_count current_activity.courts.count
  end

end

World(AdministrationHelpers)