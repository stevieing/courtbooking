require "test_helper"

class CourtsTableTest < ActiveSupport::TestCase

  attr_reader :courts, :court, :slots, :date, :member

  def setup
    stub_settings
    @courts = create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "07:00", opening_time_to: "17:00")
    @court = create(:court_with_defined_opening_and_peak_times, opening_time_from: "07:00", opening_time_to: "16:00")
    @slots = Slots::Base.new(slot_first: "07:00", slot_last: "17:00", slot_time: 30, courts: Court.all)
    Settings.stubs(:slots).returns(@slots)
    @date = Date.today+1
    @member = create(:member)
  end

  test "table header should be the date" do
    table = CourtsTable.new(date, member, slots)
    assert_equal @date.to_s(:uk), table.heading
  end

  test "all courts closures should remove slots and create closure message" do
    closure = create(:closure, date_from: date, court_ids: Court.pluck(:id),
      date_to: date+1, time_from: "12:00", time_to: "15:00")
    table = CourtsTable.new(date, member, slots)
    assert_equal 17, table.grid.count
    assert_equal closure.message, table.closure_message
  end

  test "if the court is closed slot should be closed" do
    table = CourtsTable.new(date, member, slots)
    assert table.find("16:30", @court.id).cell.closed?
    assert table.find("17:00", @court.id).cell.closed?
  end

  test "closures should be added to the table" do
    closure = create(:closure, date_from: date, date_to: date+1,
      time_from: "13:30", time_to: "15:00", courts: courts)
    table = CourtsTable.new(date, member, slots)
    assert_instance_of Slots::Cell::Activity, table.find("13:30", courts.first.id).cell
    assert_instance_of Slots::Cell::Activity, table.find("13:30", courts.last.id).cell
    assert_equal closure.description, table.find("13:30", courts.first.id).cell.text
    assert table.find("14:00", courts.first.id).cell.blank?
    assert table.find("14:30", courts.first.id).cell.blank?
    assert table.find("14:30", courts.last.id).cell.blank?
  end

  test "events should be added to the table" do
    event = create(:event, date_from: date, time_from: "09:00", time_to: "10:30", courts: courts)
    table = CourtsTable.new(date, member, slots)
    assert_instance_of Slots::Cell::Activity, table.find("09:00", courts.first.id).cell
    assert_instance_of Slots::Cell::Activity, table.find("09:00", courts.last.id).cell
    assert_equal event.description, table.find("09:00", courts.first.id).cell.text
    assert table.find("09:30", courts.first.id).cell.blank?
    assert table.find("10:00", courts.first.id).cell.blank?
  end

  test "bookings should be added to the table" do
    booking1 = create(:booking, user: member, date_from: date, time_from: "08:00", time_to: "08:30", court: courts.first)
    booking2 = create(:booking, user: member, date_from: date, time_from: "16:30", time_to: "17:00", court: courts.last)
    table = CourtsTable.new(date, member, slots)
    assert_instance_of Slots::Cell::Booking, table.find("08:00", courts.first.id).cell
    assert_equal booking1.players, table.find("08:00", courts.first.id).cell.text
    assert_instance_of Slots::Cell::Booking, table.find("16:30", courts.last.id).cell
  end

  test "all empty cells should be filled with new bookings" do
    table = CourtsTable.new(date, member, slots)
    booking = build(:booking, date_from: date, time_from: "07:00", time_to: "07:30", court: courts.first)
    assert_instance_of Slots::Cell::Booking, table.find("07:00", courts.first.id).cell
    assert_instance_of Slots::Cell::Booking, table.find("12:00", courts[2].id).cell
    assert_instance_of Slots::Cell::Booking, table.find("17:00", courts.last.id).cell
    assert table.find("07:00", courts.first.id).cell.link?
    assert_equal booking.link_text, table.find("07:00", courts.first.id).cell.text
  end

  test "rows in the past should have the correct class" do
    stub_dates(date, "08:31")
    table = CourtsTable.new(date, member, slots)
    assert_equal "past", table.grid.rows["07:00"].html_class
    assert_equal "past", table.grid.rows["07:30"].html_class
    assert_equal "past", table.grid.rows["08:00"].html_class
    assert_equal "past", table.grid.rows["08:30"].html_class
    assert_nil table.grid.rows["09:00"].html_class
  end

  test "if the date is tomorrow rows in the future should not be in the past" do
    stub_dates(date, "08:31")
    table = CourtsTable.new(date+1, member, slots)
    assert_nil table.grid.rows["07:00"].html_class
    assert_nil table.grid.rows["08:30"].html_class
    assert_nil table.grid.rows["09:00"].html_class
  end


end