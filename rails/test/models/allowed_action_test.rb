require "test_helper"

class AllowedActionTest < ActiveSupport::TestCase

  test "allowed action should not be valid without name" do
    refute build(:allowed_action, name: nil).valid?
  end

  test "allowed action should not be valid without controller" do
    refute build(:allowed_action, controller: nil).valid?
  end

  test "allowed action should not be valid without action" do
    refute build(:allowed_action, action: nil).valid?
  end

  test "allowed_action with action_text should be valid" do
    allowed_action = build(:allowed_action, action_text: "a,b,c,d,e")
    assert allowed_action.valid?
    assert_equal ["a","b","c","d","e"], allowed_action.action
  end

  test "allowed action can be user specific" do
    assert build(:allowed_action, user_specific: true).user_specific?
  end

  test "allowed action should normally be non user specific" do
    assert build(:allowed_action).non_user_specific?
  end

  test "allowed action can be admin" do
    assert build(:allowed_action, admin: true).admin?
  end

  test "sanitized controller should be singularised controller" do
    assert_equal :bollock, build(:allowed_action, controller: :bollocks).sanitized_controller
  end

   test "sanitized controller should be singularised last item in path of nested controller" do
    assert_equal :number, build(:allowed_action, controller: "dodgy/numbers").sanitized_controller
  end

end
