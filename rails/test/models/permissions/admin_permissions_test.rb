require "test_helper"

class AdminPermissionsTest < ActiveSupport::TestCase

  def setup
    @permissions = Permissions.permission_for(build(:admin))
  end

  test "should allow access to anything" do
    assert @permissions.allow?(:any, :thing)
    assert @permissions.allow_param?(:any, :thing)
  end

  test "should be able to modify anything" do
    assert @permissions.allow?(:bookings, :edit, build(:booking))
  end

end
