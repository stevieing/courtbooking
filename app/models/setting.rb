class Setting < ActiveRecord::Base

  attr_accessible :description, :name, :value
  
  validates_presence_of :name, :value, :description
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[a-zA-Z_]+$/
  
  include BaseSetting
  after_save :set_class_accessors

end