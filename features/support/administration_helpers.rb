module AdministrationHelpers
  
  def page_contains_all_settings?
    Setting.all.each do |setting|
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
end

World(AdministrationHelpers)