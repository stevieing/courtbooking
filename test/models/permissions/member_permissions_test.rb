require "test_helper"

class MemberPermissionsTest < ActiveSupport::TestCase

  setup :stub_settings

  def setup
    @user = create(:member)
    @other_user = create(:member)
  end

  test "no permission, no access" do
    permissions = Permissions.permission_for(@user)
    refute permissions.allow?(:bookings, :index)
    refute permissions.allow?(:admin, :index)
  end

  test "with read permissions should be able to access actions but not parameters" do
    add_permissions [:bookings_index], @user
    permissions = Permissions.permission_for(@user)
    assert permissions.allow?(:bookings, :index)
    refute permissions.allow_param?(:booking, :date_from)
  end

  test "with create permissions should be able to access actions and parameters" do
    add_permissions [:bookings_new], @user
    permissions = Permissions.permission_for(@user)
    assert permissions.allow?(:bookings, :new)
    assert permissions.allow_param?(:booking, :opponent_id)
    refute permissions.allow_param?(:booking, :user_id)
    assert permissions.allow_param?(:booking, :date_from)
    assert permissions.allow_param?(:booking, :time_from)
    assert permissions.allow_param?(:booking, :time_to)
    assert permissions.allow_param?(:booking, :court_id)
    assert permissions.allow_param?(:booking, :opponent_name)
    assert permissions.allow_param?(:booking, :court_slot_id)
  end

  test "with edit permissions should only be able to edit records they own" do
    add_permissions [:bookings_edit], @user
    @permissions = Permissions.permission_for(@user)
    assert @permissions.allow?(:bookings, :edit, build(:booking, user: @user))
    assert @permissions.allow?(:bookings, :edit, BookingForm.new(@user, build(:booking, user: @user)))
    refute @permissions.allow?(:bookings, :edit, build(:booking, user: @other_user))
  end

  test "with edit all permissions should be able to edit anyones records" do
    add_permissions [:bookings_edit, :edit_all_bookings], @user
    permissions = Permissions.permission_for(@user)
    assert permissions.allow?(:bookings, :destroy, build(:booking, user: @user))
    assert permissions.allow?(:bookings, :edit, build(:booking, user: @user))
    assert permissions.allow?(:bookings, :update, build(:booking, user: @user))
    assert permissions.allow?(:bookings, :destroy, build(:booking, user: @other_user))
    assert permissions.allow?(:bookings, :edit, build(:booking, user: @other_user))
    assert permissions.allow?(:bookings, :update, build(:booking, user: @other_user))
  end

  test "with permission to add an opponent should not be able to edit that opponent" do
    add_permissions [:users_index], @user
    permissions = Permissions.permission_for(@user)
    assert permissions.allow?(:users, :index)
    refute permissions.allow?(:members, :edit)
    refute permissions.allow_param?(:user, :username)
  end

  test "admin permission should allow access to all actions and parameters" do
    add_permissions [:manage_members], @user
    permissions = Permissions.permission_for(@user)
    assert permissions.allow?("admin/members", :index)
    assert permissions.allow?("admin/members", :new)
    assert permissions.allow?("admin/members", :create)
    assert permissions.allow?("admin/members", :edit)
    assert permissions.allow?("admin/members", :update)
    assert permissions.allow?("admin/members", :destroy)
    assert permissions.allow_param?(:member, :username)
    assert permissions.allow_param?(:member, :full_name)
    assert permissions.allow_param?(:member, :email)
    assert permissions.allow_param?(:member, :password)
    assert permissions.allow_param?(:member, :password_confirmation)
    assert permissions.allow_param?(:member, :mail_me)
    assert permissions.allow_param?(:member, :allowed_action_ids => [])
  end

  test "permit_new! should whitelist parameters" do
    permissions = Permissions.permission_for(@user)
    @permitted = permissions.permit_new!(:booking, ActionController::Parameters.new(attributes_for(:booking)))
    assert @permitted.permitted?
  end

end