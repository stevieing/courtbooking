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
end

World(AdministrationHelpers)