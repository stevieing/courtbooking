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
    "dodgyemailaddress.co.uk"
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
    expect(court.send(object)).to_not be_empty
  end

  def valid_user_details
    user = build(:user)
    {username: user.username, full_name: user.full_name, email: user.email, password: user.password, password_confirmation: user.password}
  end

  def has_multiple_court_times(court_number, number, object)
    court = Court.find_by :number => court_number
    expect(court.send(object).count).to eq(number.to_i)
  end

  def remove_court_time(n, type)
    within("##{type}_time_#{n}") do
      click_link "Remove"
    end
  end

  def add_user_permissions
    AllowedAction.all.each do |allowed_action|
      check allowed_action.name
    end
  end

  def remove_permission
    uncheck AllowedAction.all.last.name
  end

  def user_should_have_standard_permissions(email_address)
    expect(User.find_by(:email => email_address).permissions.count).to eq(AllowedAction.all.count)
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

  def add_valid_allowed_action(allowed_action)
    fill_in "Name", with: allowed_action.name
    fill_in "Controller", with: allowed_action.controller
    fill_in "Action", with: allowed_action.action.join(",")
    check "User specific"
    check "Admin"
  end

  def modify_allowed_action_name
    fill_in "Name", with: build(:bookings_index).name
  end

  def create_overlapping_booking(activity, court_id)
    create(:booking, date_from: activity.date_from, time_from: activity.time_from, time_to: activity.time_from.time_step(slot_time), court_id: court_id)
  end

end

World(AdministrationHelpers)