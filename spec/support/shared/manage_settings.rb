module ManageSettings
  
  def create_setting(name, value, description)
    unless Rails.configuration.respond_to? name
      FactoryGirl.create(:setting, name: name, value: value, description: description)
    end
  end
  
  def create_settings(*settings)
    settings.each do |setting|
      unless Rails.configuration.respond_to? setting
        FactoryGirl.create(setting)
      end
    end
  end
end