require "test_helper"

class GuestPermissionsTest < ActiveSupport::TestCase

  def setup
    @permissions = Permissions.permission_for(build(:guest))
  end

  test "should allow access to sign in" do
    assert @permissions.allow?("devise/sessions", :new)
    assert @permissions.allow?("devise/sessions", :create)
    assert @permissions.allow?("devise/sessions", :destroy)
  end

  test "should allow access to change password" do
    assert @permissions.allow?("devise/passwords", :new)
    assert @permissions.allow?("devise/passwords", :create)
    assert @permissions.allow?("devise/passwords", :edit)
    assert @permissions.allow?("devise/passwords", :update)
  end

  test "should allow access to courts page" do
    assert @permissions.allow?(:courts, :index)
  end

  test "should not be able to edit anything" do
    refute @permissions.allow?(:bookings, :edit, build(:booking))
  end
end