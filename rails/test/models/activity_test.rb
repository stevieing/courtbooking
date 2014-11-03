require "test_helper"

class ActivityTest < ActiveSupport::TestCase

  test "activity should not be valid without date_from" do
    refute build(:activity, date_from: nil).valid?
  end

  test "activity should not be valid without time_from" do
    refute build(:activity, time_from: nil).valid?
  end

  test "activity should not be valid without time_to" do
    refute build(:activity, time_to: nil).valid?
  end

  test "activity should not be valid without description" do
    refute build(:activity, description: nil).valid?
  end

  test "activity should not be valid without courts" do
    refute build(:activity, courts: [Court.new]).valid?
  end

  test "closure should not be valid without date_to" do
    refute build(:closure, date_to: nil).valid?
  end

  test "date_to should not be after date_from for closure" do
    refute build(:closure, date_to: Date.today-1, date_from: Date.today).valid?
  end

  test "activity time_from should be in the correct format" do
    refute build(:activity, time_from: "1045").valid?
    refute build(:activity, time_from: "invalud").valid?
    refute build(:activity, time_from: "25:45").valid?
    refute build(:activity, time_from: "10:63").valid?
  end

   test "activity time_to should be in the correct format" do
    refute build(:activity, time_to: "1045").valid?
    refute build(:activity, time_to: "invalud").valid?
    refute build(:activity, time_to: "25:45").valid?
    refute build(:activity, time_to: "10:63").valid?
  end

  test "time from should not be after time to" do
    refute build(:activity, time_from: "22:20", time_to: "21:40").valid?
  end

  test "closures by_day should return correct closures for that day" do
    create_list(:closure, 3, date_from: Date.today, date_to: Date.today+5)
    create_list(:closure, 2, date_from: Date.today+4, date_to: Date.today+8)
    assert_equal 3, Closure.by_day(Date.today).count
    assert_equal 5, Closure.by_day(Date.today+5).count
    assert_equal 2, Closure.by_day(Date.today+7).count
  end

  test "events by_day should return correct events for that day" do
    create_list(:event,3, date_from: Date.today)
    create_list(:event,2, date_from: Date.today+1)
    assert_equal 3, Event.by_day(Date.today).count
  end

  test "#court_numbers should return court numbers as a comma delimited string" do
    courts = create_list(:court, 2)
    closure = create(:closure, courts: courts)
    assert_equal Court.pluck(:number).join(","), closure.court_numbers
  end

  test "#order should order activities by date and then time" do
    activity1 = create(:activity, date_from: Date.today, time_from: "09:00")
    activity2 = create(:activity, date_from: Date.today+1, time_from: "09:00")
    activity3 = create(:activity, date_from: Date.today+1, time_from: "09:40")
    ordered = Activity.ordered
    assert_equal activity3, ordered.first
    assert_equal activity2, ordered[1]
    assert_equal activity1, ordered.last
  end

  test "closure should have the correct type" do
    assert_equal "Closure", build(:closure).type
  end

  test "event should have the correct type" do
    assert_equal "Event", build(:event).type
  end

  test "closure message should be combination of court numbers dates and times" do
    closure = build(:closure, courts: create_list(:court, 2))
    assert_equal "Courts #{closure.courts.pluck(:number).join(',')} closed from #{closure.time_from} to #{closure.time_to} for #{closure.description}.",
      closure.message
  end

  test "activity without should remove activities" do
    closures = create_list(:closure, 4)
    events = create_list(:event, 4)
    assert_equal 3, Closure.without(closures.first).count
    assert_equal 3, Event.without(events.first).count
  end

end