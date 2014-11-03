require "test_helper"

class CourtTest < ActiveSupport::TestCase

  test "should not be valid without number" do
    refute build(:court, number: nil).valid?
  end

  test "should not be valid without unique number" do
    create(:court, number: 1)
    refute build(:court, number: 1).valid?
  end

  test "#peak_time? should define when court is during peak time" do
    court = create(:court_with_defined_opening_and_peak_times, peak_time_from: "17:40", peak_time_to: "19:00")
    assert Court.peak_time?(court.id, 1, "18:00")
    refute Court.peak_time?(court.id, 2, "19:20")
  end

  test "#next_court_number should provide next available court number" do
    assert 1, Court.next_court_number
    courts = create_list(:court, 3)
    assert courts.last.number+1, Court.next_court_number
  end

  test "#by_day should determine if a court is open on a particular day" do
    court = create(:court)
    assert Court.by_day(Date.today).empty?
    court = create(:court_with_defined_opening_and_peak_times)
    refute Court.by_day(Date.today).empty?
  end

  test "#ordered should return courts ordered by number" do
    court1 = create(:court, number: 8)
    court2 = create(:court, number: 4)
    court3 = create(:court, number: 6)
    court4 = create(:court, number: 7)
    assert_equal [court2, court3, court4, court1], Court.ordered.to_a
  end


end