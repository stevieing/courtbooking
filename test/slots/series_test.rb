require "test_helper"

class SeriesTest < ActiveSupport::TestCase

  attr_reader :series, :slot, :constraints

  def setup
    @slot = Slots::Slot.new("06:00", "08:00")
    @constraints = Slots::Constraints.new(slot_first: "06:00", slot_last: "08:00", slot_time: 30)
    @series = Slots::Series.new(@slot, @constraints)
  end

  test "series should full be correct with constraints" do
    assert_equal ["06:00", "06:30", "07:00", "07:30", "08:00"], series.all
  end

  test "to_a should equal series" do
    assert_equal ["06:00", "06:30", "07:00", "07:30", "08:00"], series.to_a
  end

  test "without constraints series should be equal to two slots" do
    series = Slots::Series.new(slot, Slots::NullObject.new)
    assert_equal ["06:00", "08:00"], series.all
    assert_equal ["06:00", "08:00"], series.to_a
  end

  test "#include? should be true when slot is within series" do
    slot_within = Slots::Series.new(Slots::Slot.new("06:30", "07:30"), constraints)
    assert series.include? slot_within
  end

  test "#include? should be false when slot overlaps series" do
    slot_overlap = Slots::Series.new(Slots::Slot.new("08:00", "08:30"), constraints)
    refute series.include? slot_overlap
  end

  test "#include? should be false when slot is outside series" do
    slot_outside = Slots::Series.new(Slots::Slot.new("09:00", "09:30"), constraints)
    refute series.include? slot_outside
  end

  test "#cover?" do
    refute series.cover? "05:00"
    refute series.cover? "05:59"
    assert series.cover? "06:00"
    assert series.cover? "07:00"
    assert series.cover? "08:00"
    refute series.cover? "08:01"
    refute series.cover? "09:00"
  end

  test "#cover? should work whatever the day" do
    Time.stubs(:now).returns((Date.today-2.days).to_time)
    refute series.cover? "05:00"
    assert series.cover? "06:00"
  end

  test "#except should return difference between two series" do
    this_series = Slots::Series.new(Slots::Slot.new("08:00", "12:00"), constraints)
    that_series = Slots::Series.new(Slots::Slot.new("08:00", "11:00"), constraints)
    assert_equal ["11:30", "12:00"], this_series.except(that_series)
  end

  test "#remove! should remove specified slots" do
    series.remove!(["07:30","08:00"])
    assert_equal ["06:00","06:30", "07:00"], series.range
  end

  test "dup should dup range" do
    new_series = series.dup
    new_series.remove!(["07:30","08:00"])
    assert_equal 3, new_series.range.count
    assert_equal 5, series.range.count
  end

  test "#popped should return range - 1" do
    assert_equal ["06:00", "06:30", "07:00", "07:30"], series.popped
  end

end