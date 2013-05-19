class Court < ActiveRecord::Base
  attr_accessible :number
  
  validates_presence_of :number
end
