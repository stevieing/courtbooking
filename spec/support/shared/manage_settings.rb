module ManageSettings
  
  def create_setting(name, value, description)
    unless Setting.respond_to? name
      FactoryGirl.create(:setting, name: name, value: value, description: description)
    end
  end
end