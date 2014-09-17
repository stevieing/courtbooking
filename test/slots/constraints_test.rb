require "test_helper"

class ConstraintsTest < ActiveSupport::TestCase

  attr_reader :constraints

  def setup
    @constraints = Slots::Constraints.new(
      slot_first: "06:00", slot_last: "17:00", slot_time: 30)
  end

  test "should be valid with valid attributes" do
    assert constraints.valid?
  end

  test "should convert time" do
    assert_instance_of Time, constraints.slot_first
  end

  test "constraints should cover correct slots" do
    refute constraints.cover? "05:00"
    assert constraints.cover? "06:00"
  end

end