require "test_helper"

class SlotTest < ActiveSupport::TestCase

  attr_reader :slot, :constraints

  def setup
    @slot = Slots::Slot.new(from: "06:30", to: "07:00")
    @constraints = Slots::Constraints.new(slot_first: "07:00", slot_last: "12:00", slot_time: 30)
  end

  test "#to_a for basic slot should equal from and to" do
    assert_equal ["06:30"], slot.to_a
  end

  test "#between for basic slot should be 1" do
    assert_equal 1, slot.between
  end

  test "basic slot should be valid with from and to" do
    assert slot.valid?
  end

  test "basic slot should have type :basic" do
    assert :basic, slot.type
  end

  test "basic slot should not be valid without from or to" do
    refute Slots::Slot.new(from: "06:30").valid?
    refute Slots::Slot.new(to: "06:30").valid?
  end

  test "#== should test equality of two slots" do
    assert slot == Slots::Slot.new(from: "06:30", to: "07:00")
    refute slot == Slots::Slot.new(from: "07:30", to: "08:00")
  end

  test "slot with constraints and no to should fill to and create basic slot" do
    slot = Slots::Slot.new(from: "08:00", constraints: constraints)
    assert 1, slot.between
    assert_equal "08:30", slot.to
  end

  test "slot with constraints and no to should only be valid if from is within series" do
    assert Slots::Slot.new(from: "08:00", constraints: constraints).valid?
    refute Slots::Slot.new(from: "06:00", constraints: constraints).valid?
    refute Slots::Slot.new(from: "13:00", constraints: constraints).valid?
  end

  test "slot with from, to and constraints should create a series" do
    slot = Slots::Slot.new(from: "08:00", to: "12:00", constraints: constraints)
    assert slot.valid?
    assert_equal 8, slot.between
    assert ["08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00"], slot.all
  end

  test "class method #combine_series should create a single series for all of the slots" do
    slot1 = Slots::Slot.new(from: "08:00", to: "10:00", constraints: constraints)
    slot2 = Slots::Slot.new(from: "09:00", to: "11:00", constraints: constraints)
    assert_equal Slots::Series.combine([slot1.series,slot2.series]), Slots::Slot.combine_series([slot1, slot2])
  end

  test "slot created from a booking should be valid" do
    booking = build(:booking, time_from: "07:00", time_to: "09:00")
    slot = Slots::Slot.new(object: booking)
    assert slot.valid?
    assert_equal booking.time_from, slot.from
    assert_equal booking.time_to, slot.to
    assert_equal :booking, slot.type
  end

  test "slot created from an activity should be valid" do
    closure = build(:closure, time_from: "07:00", time_to: "11:00")
    slot = Slots::Slot.new(object: closure, constraints: constraints)
    assert slot.valid?
    assert_equal closure.time_from, slot.from
    assert_equal closure.time_to, slot.to
    assert_equal :closure, slot.type
    assert slot.activity?
  end

  test "a slot created from an activity that covers the last slot of the day should have a full series" do
    closure = build(:closure, time_from: "07:00", time_to: "12:00")
    slot = Slots::Slot.new(object: closure, constraints: constraints)
    assert_equal "11:30", slot.series.all.last
    assert_equal 10, slot.between
  end

   test "a slot created from an activity that does not cover the last slot of the day should not have a full series" do
    closure = build(:closure, time_from: "07:00", time_to: "11:30")
    slot = Slots::Slot.new(object: closure, constraints: constraints)
    assert_equal "11:00", slot.series.all.last
    assert_equal 9, slot.between
  end

  test "#adjusted_to will return the correct time for the last time in the series" do
    assert slot.to, slot.adjusted_to
    closure = build(:closure, time_from: "07:00", time_to: "11:00")
    slot = Slots::Slot.new(object: closure, constraints: constraints)
    assert_equal "10:30", slot.adjusted_to
  end

end