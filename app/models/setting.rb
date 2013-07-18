class Setting < ActiveRecord::Base
  
  include AppConfig
  
  validates_presence_of :name, :value, :description
  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A[a-zA-Z_]+\z/

  after_save :add_config
  
end