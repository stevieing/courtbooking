class ActionPermission < Permission
  
  validates_presence_of :controller, :actions
end