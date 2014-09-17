require "test_helper"

class CellTest < ActiveSupport::TestCase

  class TestCell
    include Slots::Cell::Base
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
    cell = Slots::Cell::Blank.new
    assert cell.blank?
  end

  test "text cell with no attributes should have the correct attributes" do
    cell = Slots::Cell::Text.new
    refute cell.link?
    assert_equal 1, cell.span
    assert_equal " ", cell.text
    assert_nil cell.html_class
  end

  test "text cell with added text should not be empty" do
    cell = Slots::Cell::Text.new("some text")
    assert_equal "some text", cell.text
  end

  test "closed cell should behave as if it is closed" do
    cell = Slots::Cell::Closed.new
    assert cell.closed?
    assert_equal "closed", cell.html_class
  end

  test "booking cell with new booking in the future should be a link to create a new booking" do
    booking = build(:booking, date_from: Date.today+2)
    cell = Slots::Cell::Booking.new(booking, @member)
    assert_equal booking.link_text, cell.text
    assert_equal court_booking_path(booking.new_attributes), cell.link
    assert_equal "free", cell.html_class
  end

  test "booking cell with new booking in the past should not be a link to create a new booking" do
    booking = build(:booking, date_from: Date.today+2)
    stub_dates(Date.today+3)
    cell = Slots::Cell::Booking.new(booking, @member)
    assert_equal booking.players, cell.text
    refute cell.link?
    assert_equal "free", cell.html_class
  end

  test "booking cell with existing booking in the past should not be editable" do
    booking = create(:booking, date_from: Date.today+2)
    stub_dates(Date.today+3)
    cell = Slots::Cell::Booking.new(booking, @member)
    assert_equal booking.players, cell.text
    refute cell.link?
    assert_equal "booking", cell.html_class
  end

  test "booking cell with existing booking in the future should not be editable without correct permissions" do
    booking = create(:booking, date_from: Date.today+2)
    cell = Slots::Cell::Booking.new(booking, @member)
    assert_equal booking.players, cell.text
    refute cell.link?
    assert_equal "booking", cell.html_class
  end

   test "booking cell with existing booking in the future should be editable with correct permissions" do
    booking = create(:booking, date_from: Date.today+2)
    @member.stubs(:allow?).with(:bookings, :edit, booking).returns(true)
    cell = Slots::Cell::Booking.new(booking, @member)
    assert_equal booking.players, cell.text
    assert_equal edit_booking_path(booking), cell.link
    assert_equal "booking", cell.html_class
  end

  test "activity cell with closure should have correct attributes" do
    closure = build(:closure)
    cell = Slots::Cell::Activity.new(closure)
    assert_equal closure.description, cell.text
    assert_equal closure.slot.between, cell.span
    assert_equal "closure", cell.html_class

  end

  test "activity cell with event should have correct html class" do
    event = build(:event)
    cell = Slots::Cell::Activity.new(event)
    assert_equal "event", cell.html_class
  end

  test "calendar date cell should have correct attributes" do
    date = Date.today
    cell = Slots::Cell::CalendarDate.new(date, date+1)
    assert_equal date.day_of_month, cell.text
    assert_equal courts_path(date.to_s), cell.link
    assert_nil cell.html_class
  end

  test "calendar date cell where date is current date should not be a link and should have current html class" do
    date = Date.today
    cell = Slots::Cell::CalendarDate.new(date, date)
    refute cell.link?
    assert_equal "selected", cell.html_class
  end

end