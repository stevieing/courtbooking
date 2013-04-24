module BaseSetting
  def self.included(base)
    base.extend ClassMethods
    base.all.each do |instance|
      instance.set_class_accessors
    end
  end
  
  def set_class_accessors
    self.class.set_class_accessors(self.name, self.value)
  end
  
  module ClassMethods
    def set_class_accessors(attribute, value)
      self.class.class_eval do
        define_method attribute do
          value
        end
        define_method "#{attribute}=" do |value|
          attribute = value
        end
      end
    end
  end

end