require "spec_helper"

describe Permissions::GuestPermission do
  
  describe "as a guest" do
    subject { Permissions.permission_for(nil) }
    it {should allow_action("devise/sessions", :new)}
    it {should allow_action("devise/sessions", :create)}
    it {should_not allow_action("devise/sessions", :destroy)}
    it {should allow_action(:courts, :index)}
  end
  
end