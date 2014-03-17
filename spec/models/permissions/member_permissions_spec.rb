require "spec_helper"

describe Permissions::MemberPermission do

  let!(:user)          { create(:user, admin: false) }
  let!(:other_user)    { create(:user, admin: false) }
  let(:user_booking)   { build(:booking, user: user) }
  let(:other_booking)  { build(:booking, user: other_user) }
  subject              { Permissions.permission_for(user) }

  before(:each) do
    add_standard_permissions user
  end

  it "allows courts" do
    should allow_action(:courts, :index)
  end

  it "allows bookings" do
    should allow_action(:bookings, :index)
    should allow_action(:bookings, :new)
    should allow_action(:bookings, :create)
    should allow_action(:bookings, :show)
    should allow_action(:bookings, :destroy, user_booking)
    should allow_action(:bookings, :edit, user_booking)
    should allow_action(:bookings, :update, user_booking)
    should_not allow_action(:bookings, :destroy, other_booking)
    should_not allow_action(:bookings, :edit, other_booking)
    should_not allow_action(:bookings, :update, other_booking)
    should allow_param(:booking, :time_and_place)
    should_not allow_param(:booking, :playing_on_text)
    should_not allow_param(:booking, :court_number)
    should allow_param(:booking, :opponent_id)
    should_not allow_param(:booking, :user_id)
    should_not allow_param(:booking, :playing_on)
    should_not allow_param(:booking, :playing_from)
    should_not allow_param(:booking, :playing_to)
  end

  it "allows sessions" do
    should allow_action("devise/sessions", :destroy)
    should allow_action("devise/sessions", :create)
  end

  it {should_not allow_action(:admin, :index)}

  it "allows edit my details" do
    should allow_action(:users, :edit, user)
    should allow_action(:users, :update, user)
    should_not allow_action(:users, :edit, other_user)
    should_not allow_action(:users, :update, other_user)
    should allow_param(:user, :username)
    should allow_param(:user, :full_name)
    should allow_param(:user, :email)
    should allow_param(:user, :password)
    should allow_param(:user, :password_confirmation)
    should allow_param(:user, :mail_me)
    should_not allow_param(:user, :permission_ids => [])
  end

end