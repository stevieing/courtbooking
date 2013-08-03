class AllowedAction < ActiveRecord::Base
  
  validates_presence_of :name, :controller, :action
  serialize :action, Array
  
end
