require "test_helper"

class CourtTimesTest < ActiveSupport::TestCase

  def setup
  end

  test "should not be valid without time_from" do
    refute build(:court_time, time_from: nil).valid?
  end

  test "should not be valid without time_to" do
    refute build(:court_time, time_to: nil).valid?
  end

  test "should not be valid without day" do
    refute build(:court_time, day: nil).valid?
  end

  test "when opening_times are added should ensure court is open" do
    court = create(:court_with_defined_opening_and_peak_times, opening_time_from: "08:00", opening_time_to: "12:00" )
    refute court.open?(0, "07:00")
    assert court.open?(0,"08:00")
    assert court.open?(0,"10:00")
    assert court.open?(0,"12:00")
    refute court.open?(0,"13:00")
  end

  test "peak time should not be valid when time_from is after time_to" do
    refute build(:court_time, day: 0, time_from: "22:20", time_to: "21:40").valid?
  end

  test "we should be able to get opening times by day" do
    court = create(:court_with_defined_opening_and_peak_times, opening_time_from: "08:00", opening_time_to: "12:00" )
    assert_equal 1, court.opening_times.by_day(0).count
  end

end