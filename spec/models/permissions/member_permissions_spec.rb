require "spec_helper"

describe Permissions::MemberPermission, :focus => true do

  describe "as a member" do
    subject { Permissions.permission_for(build(:user)) }
    it {should allow(:courts,:index)}
    it {should allow(:bookings,:index)}
    it {should allow(:home,:index)}
    it {should allow("devise/sessions",:destroy)}
    it {should_not allow(:admin,:index)}
  end
end