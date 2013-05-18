class Setting < ActiveRecord::Base
  
  include AppConfig

  attr_accessible :description, :name, :value
  
  validates_presence_of :name, :value, :description
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[a-zA-Z_]+$/

  after_save :add_config
  
end