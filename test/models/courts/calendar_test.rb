require "test_helper"

class CalendarTest < ActiveSupport::TestCase

  attr_reader :date, :current_date, :calendar

  def setup
    @date = Date.today
    @current_date = Date.today+10
    @calendar = Courts::Calendar.new(current_date: current_date, no_of_days: 20)
  end

  test "calendar should have the correct heading and html class" do
    assert_equal date.calendar_header(date+20), calendar.heading
    assert_equal "calendar", calendar.html_class
  end

  test "calendar should have a header which includes abbreviated days of week" do
    assert_equal 7, calendar.rows[:header].count
    assert_equal date.strftime('%a'), calendar.find(:header, date.strftime('%a')).text
    assert_equal (date+6).strftime('%a'), calendar.find(:header,(date+6).strftime('%a')).text
  end

  test "calendar should have correct number of rows and columns and types of cells" do
    assert_equal 4, calendar.rows.count
    assert_equal 7, calendar.find("0").count
    assert_equal 7, calendar.find("1").count
    assert_equal 6, calendar.find("2").count
    assert_instance_of Table::Cell::CalendarDate, calendar.find("0",date.day_of_month)
    assert_instance_of Table::Cell::CalendarDate, calendar.find("2",(date+19).day_of_month)
    assert_instance_of Table::Cell::CalendarDate, calendar.find("1",(current_date).day_of_month)
  end

end