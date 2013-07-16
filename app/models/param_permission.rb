class ParamPermission < Permission
  
  validates_presence_of :resource, :attrs
end