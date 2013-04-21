class Setting < ActiveRecord::Base
  
  @@klass = class << self; self; end

  attr_accessible :description, :name, :value
  
  validates_presence_of :name, :value, :description
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[a-zA-Z_]+$/
  after_save :set_class_accessors
  
  def set_class_accessors
    set_class_reader self.name, read_attribute(:value)
    set_class_writer self.id, self.name
  end
  
  private
  
  def set_class_reader(attr, val)
    @@klass.send(:define_method, "#{attr}") { val }
  end
  
  def set_class_writer(id, attr)
    @@klass.send(:define_method, "#{attr}=") {|v| Setting.find(id).update_attributes!(value: v)}
  end
  
  #TODO: Need to find a way to load class methods on each load of class without this hack
  Setting.all.each do |setting|
    setting.set_class_accessors
  end
  
end