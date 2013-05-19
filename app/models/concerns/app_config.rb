module AppConfig
  
  def add_config
    create_config_method self.name, self.value.to_type unless self.value.nil?
  end
  
  private
  
  def create_config_method(name, value)
    Rails.configuration.class_eval do
      define_method(name) { value }
    end
  end
  
end