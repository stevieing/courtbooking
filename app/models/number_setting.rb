class NumberSetting < Setting
 
  validates_numericality_of :value, :greater_than_or_equal_to => 1
  
end