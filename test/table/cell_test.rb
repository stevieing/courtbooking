require "test_helper"

class CellTest < ActiveSupport::TestCase

  class TestCell
    include Table::Cell::Base
  end

  def setup
    stub_settings
    @member = create(:member)
  end

  test "base cell should respond to all correct methods" do
    cell = TestCell.new
    refute cell.blank?
    refute cell.link?
    refute cell.closed?
    assert_equal 1, cell.span
  end

  test "blank cell should be blank" do
    cell = Table::Cell::Blank.new
    assert cell.blank?
  end

  test "text cell with no attributes should have the correct attributes" do
    cell = Table::Cell::Text.new
    refute cell.link?
    assert_equal 1, cell.span
    assert_equal " ", cell.text
    assert_nil cell.html_class
  end

  test "text cell with added text should not be empty" do
    cell = Table::Cell::Text.new("some text")
    assert_equal "some text", cell.text
  end

  test "closed cell should behave as if it is closed" do
    cell = Table::Cell::Closed.new
    assert cell.closed?
    assert_equal "closed", cell.html_class
  end

  test "booking cell with new booking in the future should be a link to create a new booking" do
    court_slot = build(:court_slot)
    booking = build(:booking, date_from: Date.today+2)
    cell = Table::Cell::Booking.new(booking, @member, court_slot)
    assert_equal booking.link_text, cell.text
    assert_equal court_booking_path(booking.date_from, court_slot.id), cell.link
    assert_equal "free", cell.html_class
  end

  test "booking cell with new booking in the past should not be a link to create a new booking" do
    court_slot = build(:court_slot)
    booking = build(:booking, date_from: Date.today+2)
    stub_dates(Date.today+3)
    cell = Table::Cell::Booking.new(booking, @member, court_slot)
    assert_equal booking.players, cell.text
    refute cell.link?
    assert_equal "free", cell.html_class
  end

  test "booking cell with existing booking in the past should not be editable" do
    court_slot = build(:court_slot)
    booking = create(:booking, date_from: Date.today+2)
    stub_dates(Date.today+3)
    cell = Table::Cell::Booking.new(booking, @member, court_slot)
    assert_equal booking.players, cell.text
    refute cell.link?
    assert_equal "booking", cell.html_class
  end

  test "booking cell with existing booking in the future should not be editable without correct permissions" do
    court_slot = build(:court_slot)
    booking = create(:booking, date_from: Date.today+2)
    cell = Table::Cell::Booking.new(booking, @member, court_slot)
    assert_equal booking.players, cell.text
    refute cell.link?
    assert_equal "booking", cell.html_class
  end

   test "booking cell with existing booking in the future should be editable with correct permissions" do
    court_slot = build(:court_slot)
    booking = create(:booking, date_from: Date.today+2)
    @member.stubs(:allow?).with(:bookings, :edit, booking).returns(true)
    cell = Table::Cell::Booking.new(booking, @member, court_slot)
    assert_equal booking.players, cell.text
    assert_equal edit_booking_path(booking), cell.link
    assert_equal "booking", cell.html_class
  end

  test "activity cell with closure should have correct attributes" do
    closure = build(:closure)
    cell = Table::Cell::Activity.new(closure, closure.time_from)
    assert_equal closure.description, cell.text
    assert_equal closure.slot.between, cell.span
    assert_equal "closure", cell.html_class
  end

  test "activity cell which is not first slot should be blank" do
    closure = build(:closure)
    cell = Table::Cell::Activity.new(closure, closure.slot.series.all.pop)
    assert cell.blank?
    assert_nil cell.text
    assert_equal 1, cell.span
    assert_equal "closure", cell.html_class
  end

  test "activity cell with event should have correct html class" do
    event = build(:event)
    cell = Table::Cell::Activity.new(event, event.time_from)
    assert_equal "event", cell.html_class
  end

  test "calendar date cell should have correct attributes" do
    date = Date.today
    cell = Table::Cell::CalendarDate.new(date, date+1)
    assert_equal date.day_of_month, cell.text
    assert_equal courts_path(date.to_s), cell.link
    assert_nil cell.html_class
  end

  test "calendar date cell where date is current date should not be a link and should have current html class" do
    date = Date.today
    cell = Table::Cell::CalendarDate.new(date, date)
    refute cell.link?
    assert_equal "selected", cell.html_class
  end

end