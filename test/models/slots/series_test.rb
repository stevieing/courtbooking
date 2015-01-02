require "test_helper"

class SeriesTest < ActiveSupport::TestCase

  attr_reader :series, :slot, :constraints

  def setup
    @slot = Slots::Slot.new(from: "06:00", to: "08:00")
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
    series = Slots::Series.new(slot, Slots::NullConstraints.new)
    assert_equal ["06:00", "08:00"], series.all
    assert_equal ["06:00", "08:00"], series.to_a
  end

  test "#include? should be true when slot is within series" do
    slot_within = Slots::Series.new(Slots::Slot.new(from: "06:30", to: "07:30"), constraints)
    assert series.include? slot_within
  end

  test "#include? should be false when slot overlaps series" do
    slot_overlap = Slots::Series.new(Slots::Slot.new(from: "08:00", to: "08:30"), constraints)
    refute series.include? slot_overlap
  end

  test "#include? should be false when slot is outside series" do
    slot_outside = Slots::Series.new(Slots::Slot.new(from: "09:00", to: "09:30"), constraints)
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
    this_series = Slots::Series.new(Slots::Slot.new(from: "08:00", to: "12:00"), constraints)
    that_series = Slots::Series.new(Slots::Slot.new(from: "08:00", to: "11:00"), constraints)
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

  test "#<< should combine ranges for slot" do
    overlapping_series = Slots::Series.new(Slots::Slot.new(from: "07:00", to: "09:00"), constraints)
    parallel_series = Slots::Series.new(Slots::Slot.new(from: "09:00", to: "10:00"), constraints)
    assert_equal ["06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00"], (series.dup << overlapping_series).all
    assert_equal ["06:00", "06:30", "07:00", "07:30", "08:00", "09:00", "09:30", "10:00"], (series.dup << parallel_series).all
  end

  test "class method #combine should merge all series into one with a single range" do
    series1 = Slots::Series.new(Slots::Slot.new(from: "07:00", to: "09:00"), constraints)
    series2 = Slots::Series.new(Slots::Slot.new(from: "10:00", to: "11:00"), constraints)
    combined = Slots::Series.combine([series, series1, series2])
    assert_equal ["06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "10:00", "10:30", "11:00"], combined.all
  end

  test "two series with the same attributes should be equal" do
    series1 = Slots::Series.new(slot, Slots::NullConstraints.new)
    series2 = Slots::Series.new(slot, Slots::NullConstraints.new)
    assert series1 == series2
  end

  test "two series with different attributes should not be equal" do
    series1 = Slots::Series.new(slot, Slots::NullConstraints.new)
    series2 = Slots::Series.new(Slots::Slot.new(from: "06:00", to: "07:30"), Slots::NullConstraints.new)
    refute series1 == series2
  end

  test "#past should return items in series which precede the current time" do
    assert_equal series.all, series.past(Date.today-1)
    assert_empty series.past(Date.today+1)
    Time.stubs(:now).returns(Time.parse("07:00"))
    assert_equal ["06:00","06:30","07:00"], series.past(Date.today)
  end

  test "#between should be adjusted depending on whether series covers last slot" do
    assert_equal series.count, series.between
    other = Slots::Series.new(Slots::Slot.new(from: "06:00", to: "07:30"), constraints)
    assert_equal 3, other.between
  end

end