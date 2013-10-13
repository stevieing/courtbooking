module ManageSettings

  def create_setting(name, attributes = nil)
    attributes = format_attributes(attributes) if attributes.is_a? String
    if Setting.find_by_name(name).nil?
      if FactoryGirl.factories.map(&:name).include? name
        FactoryGirl.create(name, attributes)
      else
        FactoryGirl.create(:setting, attributes.nil? ? {name: name} : attributes.merge(name: name))
      end
    else
      Setting.find_by_name(name).update_attributes(attributes)
    end
  end
  
  def create_settings(*settings)
    settings.each do |setting|
      create_setting setting
    end
  end
  
  def create_standard_settings
    create_settings :days_bookings_can_be_made_in_advance, :max_peak_hours_bookings, :slot_time, :start_time, :finish_time
  end
  
  def format_attributes(text)
    Hash[text.gsub('"','').split(" and ").collect { |param| param.split(": ")}]
  end
end