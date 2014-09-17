require "test_helper"

class CalendarTest < ActiveSupport::TestCase

  attr_reader :date, :current_date, :calendar

  def setup
    @date = Date.today
    @current_date = Date.today+10
    @calendar = Calendar.new(current_date: current_date, no_of_days: 20)
  end

  test "calendar should have the correct heading" do
    assert_equal date.calendar_header(date+20), calendar.heading
  end

  test "calendar should have a header which includes abbreviated days of week" do
    assert_equal 7, calendar.rows[:header].count
    assert_equal date.strftime('%a'), calendar.rows[:header].cells[date.strftime('%a')].text
    assert_equal (date+6).strftime('%a'), calendar.rows[:header].cells[(date+6).strftime('%a')].text
  end

  test "calendar should have correct number of rows and columns and types of cells" do
    assert_equal 4, calendar.rows.count
    assert_equal 7, calendar.rows["0"].count
    assert_equal 7, calendar.rows["1"].count
    assert_equal 6, calendar.rows["2"].count
    assert_instance_of Slots::Cell::CalendarDate, calendar.rows["0"].cells[date.day_of_month]
    assert_instance_of Slots::Cell::CalendarDate, calendar.rows["2"].cells[(date+19).day_of_month]
    assert_instance_of Slots::Cell::CalendarDate, calendar.rows["1"].cells[(current_date).day_of_month]
  end

end