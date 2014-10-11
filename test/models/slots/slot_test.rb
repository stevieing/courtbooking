require "test_helper"

class SlotTest < ActiveSupport::TestCase

  def setup
    @slot = Slots::Slot.new("06:30", "07:00")
    @constraints = Slots::Constraints.new(slot_first: "07:00", slot_last: "12:00", slot_time: 30)
  end

  test "#to_a for basic slot should equal from and to" do
    assert_equal ["06:30","07:00"], @slot.to_a
  end

  test "#between for basic slot should be 1" do
    assert_equal 1, @slot.between
  end

  test "basic slot should be valid with from and to" do
    assert @slot.valid?
  end

  test "basic slot should not be valid without from or to" do
    refute Slots::Slot.new("06:30", nil).valid?
    refute Slots::Slot.new(nil, "06:30").valid?
  end

  test "#== should test equality of two slots" do
    assert @slot == Slots::Slot.new("06:30", "07:00")
    refute @slot == Slots::Slot.new("07:30", "08:00")
  end

  test "slot with constraints and no to should fill to and create basic slot" do
    @slot = Slots::Slot.new("08:00", nil, @constraints)
    assert 1, @slot.between
    assert_equal ["08:00","08:30"], @slot.all
  end

  test "slot with constraints and no to should only be valid if from is within series" do
    assert Slots::Slot.new("08:00", nil, @constraints).valid?
    refute Slots::Slot.new("06:00", nil, @constraints).valid?
    refute Slots::Slot.new("13:00", nil, @constraints).valid?
  end

  test "slot with from, to and constraints should create a series" do
    @slot = Slots::Slot.new("08:00", "12:00", @constraints)
    assert @slot.valid?
    assert 8, @slot.between
    assert ["08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00"], @slot.all
  end

end