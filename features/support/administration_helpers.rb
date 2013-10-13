module AdministrationHelpers
  
  def page_contains_all_settings?
    settings.each do |setting|
      page_contains_setting? (setting.description)
    end
  end
  
  def page_contains_setting? (setting)
    page.should have_content(setting)
  end
  
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
  
  def page_contains_all_users?
    users.each do |user|
      page_contains_user? (user.username)
    end
  end
  
  def page_contains_user? (username)
    page.should have_content(username)
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
end

World(AdministrationHelpers)