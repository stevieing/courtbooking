require 'spec_helper'

describe Permission, :focus => true do
  
  describe Permission::ActionPermission do
    
    it { should validate_presence_of(:controller) }
    it { should validate_presence_of(:actions) }
    
  end
  
  describe Permission::ParamPermission do
    
    it { should validate_presence_of(:resource) }
    it { should validate_presence_of(:attrs) }
  end

end
