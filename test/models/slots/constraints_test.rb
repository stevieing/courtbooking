require "test_helper"

class ConstraintsTest < ActiveSupport::TestCase

  attr_reader :constraints

  def setup
    @constraints = Slots::Constraints.new(
      slot_first: "12:00", slot_last: "17:00", slot_time: 30)
  end

  test "should be valid with valid attributes" do
    assert constraints.valid?
  end

  test "should convert time" do
    assert_instance_of Time, constraints.slot_first
  end

  test "constraints should cover correct slots" do
    refute constraints.cover? "11:00"
    assert constraints.cover? "12:00"
  end

  test "constraints should create an array of slots" do
    assert_equal constraints.series.count, constraints.count
    assert_instance_of Slots::Slot, constraints.first
    assert_equal "12:00", constraints.first.from
    assert_equal "12:30", constraints.first.to
    assert_equal "16:30", constraints.last.from
    assert_equal "17:00", constraints.last.to
  end

  test "#covers_last? should return true if passed slot is greater than or equal to slot_last" do
    slot = Slots::Slot.new(from: "17:00", to: "17:30")
    assert constraints.covers_last? slot
    slot = Slots::Slot.new(from: "16:30", to: "17:00")
    assert constraints.covers_last? slot
  end

  test "#slots_from should extract the start time for each slot" do
    assert_equal ["12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30"], constraints.slots_from
  end

  test "#slots_to should extract end time for each slot" do
    assert_equal ["12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00", "16:30", "17:00"], constraints.slots_to
  end

end