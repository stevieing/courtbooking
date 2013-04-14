require "spec_helper"

describe Permissions::GuestPermission, :focus => true do
  
  describe "as a guest" do
    subject { Permissions.permission_for(nil) }
    it {should allow("devise/sessions",:new)}
    it {should allow("devise/sessions",:create)}
    it {should_not allow("devise/sessions",:destroy)}
  end
  
end