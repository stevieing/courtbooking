require "spec_helper"

describe Permissions::MemberPermission do
  
  let(:user) { create(:user, admin: false) }
  let(:user_booking) { build(:booking, user_id: user.id) }
  let(:other_booking) { build(:booking, user_id: 999) }
  subject { Permissions.permission_for(user) }
  
  it "allows courts" do
    should allow(:courts,:index)
  end

  it "allows bookings" do
    should allow(:bookings,:index)
    should allow(:bookings, :new)
    should allow(:bookings, :create)
    should allow(:bookings, :show)
    should allow(:bookings, :destroy, user_booking)
    should_not allow(:bookings, :destroy, other_booking)
  end
  
  it "allows sessions" do
    should allow("devise/sessions",:destroy)
    should allow("devise/sessions",:create)
  end
  
  it {should_not allow(:admin,:index)}
  
end