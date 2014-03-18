require "spec_helper"

describe Permissions::MemberPermission, :focus => true do

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
    should_not allow_param(:user, :allowed_action_ids => [])
  end

  describe "admin permissions" do

    before(:all) do
      load "#{Rails.root}/config/initializers/accepted_attributes.rb"
    end

    before(:each) do
      add_admin_permissions user
    end

    it "allows admin index" do
      should allow_action(:admin, :index)
    end

    it "allows manage users" do
      should allow_action("admin/users", :index)
      should allow_action("admin/users", :new)
      should allow_action("admin/users", :create)
      should allow_action("admin/users", :edit)
      should allow_action("admin/users", :update)
      should allow_action("admin/users", :delete)
      should allow_param(:user, :username)
      should allow_param(:user, :full_name)
      should allow_param(:user, :email)
      should allow_param(:user, :password)
      should allow_param(:user, :password_confirmation)
      should allow_param(:user, :mail_me)
      should allow_param(:user, :allowed_action_ids => [])
    end

    it "allows manage courts" do
      should allow_action("admin/courts", :index)
      should allow_action("admin/courts", :new)
      should allow_action("admin/courts", :create)
      should allow_action("admin/courts", :edit)
      should allow_action("admin/courts", :update)
      should allow_action("admin/courts", :delete)
      should allow_param(:court, :number)
      should allow_param(:court, :peak_times => [:day, :time_from, :time_to])
      should allow_param(:court, :opening_times => [:day, :time_from, :time_to])
    end

    it "allows manage closures" do
      should allow_action("admin/closures", :index)
      should allow_action("admin/closures", :new)
      should allow_action("admin/closures", :create)
      should allow_action("admin/closures", :edit)
      should allow_action("admin/closures", :update)
      should allow_action("admin/closures", :delete)
      should allow_param(:closure, :description)
      should allow_param(:closure, :date_from)
      should allow_param(:closure, :date_to)
      should allow_param(:closure, :time_from)
      should allow_param(:closure, :time_to)
      should allow_param(:closure, :court_ids => [])
    end

    it "allows manage events" do
      should allow_action("admin/events", :index)
      should allow_action("admin/events", :new)
      should allow_action("admin/events", :create)
      should allow_action("admin/events", :edit)
      should allow_action("admin/events", :update)
      should allow_action("admin/events", :delete)
      should allow_param(:event, :description)
      should allow_param(:event, :date_from)
      should allow_param(:event, :date_to)
      should allow_param(:event, :time_from)
      should allow_param(:event, :time_to)
      should allow_param(:event, :court_ids => [])
    end

    it "allows settings" do
      should allow_action("admin/settings", :index)
      should allow_action("admin/settings", :update)
      should allow_param(:setting, :value)
    end

  end

end