class Setting < ActiveRecord::Base
  
  include AppSettings::ModelTrigger

  validates_presence_of :name, :value, :description
  validates_uniqueness_of :name
  validates_format_of :name, with: /\A[a-zA-Z_]+\z/

end