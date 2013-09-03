module AppConfig
  
  def add_config
    value = (self.value.class == String ? self.value.to_type : self.value)
    create_config_method self.name, value
  end
  
  private
  
  def create_config_method(name, value)
    Rails.configuration.class_eval do
      define_method(name) { value }
    end
  end
  
end