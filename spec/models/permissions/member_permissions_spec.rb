require "spec_helper"

describe Permissions::MemberPermission, :focus => true do
  
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
    should allow(:bookings, :edit, user_booking)
    should allow(:bookings, :update, user_booking)
    should_not allow(:bookings, :destroy, other_booking)
    should_not allow(:booking, :edit, other_booking)
    should_not allow(:booking, :update, other_booking)
    should allow_param(:booking, :time_and_place)
    should_not allow_param(:booking, :playing_at_text)
    should_not allow_param(:booking, :court_number)
    should allow_param(:booking, :opponent_user_id)
    should_not allow_param(:booking, :user_id)
    should_not allow_param(:booking, :playing_at)
  end
  
  it "allows sessions" do
    should allow("devise/sessions",:destroy)
    should allow("devise/sessions",:create)
  end
  
  it {should_not allow(:admin,:index)}
  
end